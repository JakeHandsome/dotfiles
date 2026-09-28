-- =============================================================================
-- gwt.lua: bare-repo git worktree workflow for clink (cmd.exe), using native git.
--
-- Companion to the fish function in the nix-config repo (parts/gwt.nix).
-- Same commands on both platforms:
--   gwt              list worktrees
--   gwt new <branch> create <parent-of-bare-repo>/<branch> and cd into it
--   gwt <branch|path> cd into a worktree (branch name, full path, or path leaf)
--   gwt rm <branch>  remove a worktree
--
-- How it works: clink's onfilterinput hook intercepts lines starting with gwt
-- before cmd.exe runs them. The function below calls plain git through
-- io.popen, then returns a replacement command line. For the cd verbs that
-- line is `cd /d "..."`, which cmd.exe executes in the current process, so
-- the directory change sticks. Everything else falls through to a no-op.
-- =============================================================================

local function run(cmd)
  local f = io.popen(cmd)
  local out = f:read('*a') or ''
  local ok, how, code = f:close()
  return out, (how == 'exit' and code or 1)
end

local function firstline(s)
  return (s:match('^([^\r\n]+)'))
end

local function backslashes(p)
  return (p or ''):gsub('/', '\\')
end

-- dir containing the common git dir, i.e. where the bare repo lives
local function repo_parent()
  local out = run('git rev-parse --path-format=absolute --git-common-dir')
  local d = firstline(out)
  if not d then return nil end
  return d:match('^(.*)[/\\][^/\\]+$')
end

-- match by branch name, full path, or path leaf
local function find_worktree(target)
  local cur
  local pat = target:gsub('%%', '%%%%')
  local out = run('git worktree list --porcelain')
  for line in out:gmatch('[^\r\n]+') do
    if line:sub(1, 9) == 'worktree ' then
      cur = line:sub(10)
    elseif line:sub(1, 7) == 'branch ' and cur then
      local b = line:match('^branch refs/heads/(.+)$')
      if b == target or cur == target or cur:match('[/\\]' .. pat .. '$') then
        return cur
      end
    end
  end
  return nil
end

local function on_gwt(text)
  local args = {}
  for w in text:gmatch('%S+') do args[#args + 1] = w end

  if #args == 1 then
    local out = run('git worktree list')
    io.write(out)
    return 'call', false
  end

  if args[2] == 'new' and args[3] then
    local parent = repo_parent()
    if not parent then
      io.write('gwt: not inside a git repo\n')
      return 'call', false
    end
    local path = parent .. '/' .. args[3]
    -- checkout the branch if it exists, else create it from HEAD
    local _, refcode = run('git show-ref --verify --quiet refs/heads/' .. args[3])
    local add
    if refcode == 0 then
      add = 'git worktree add "' .. backslashes(path) .. '" ' .. args[3]
    else
      add = 'git worktree add -b ' .. args[3] .. ' "' .. backslashes(path) .. '"'
    end
    local out, code = run(add)
    io.write(out)
    if code == 0 then
      return 'cd /d "' .. backslashes(path) .. '"', false
    end
    return 'call', false
  end

  if args[2] == 'rm' and args[3] then
    local p = find_worktree(args[3])
    if p then
      local out = run('git worktree remove "' .. backslashes(p) .. '"')
      io.write(out)
    else
      io.write('gwt: no worktree matching ' .. args[3] .. '\n')
    end
    return 'call', false
  end

  local p = find_worktree(args[2])
  if p then
    return 'cd /d "' .. backslashes(p) .. '"', false
  end
  io.write('gwt: no worktree matching ' .. args[2] .. '\n')
  return 'call', false
end

if clink.onfilterinput then
  clink.onfilterinput(function(text)
    if text:match('^%s*gwt%S*') then return on_gwt(text) end
  end)
else
  -- fallback for old clink (< 1.2.x)
  clink.onendedit(function(text)
    if text:match('^%s*gwt%S*') then return on_gwt(text) end
  end)
end
