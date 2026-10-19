-- =============================================================================
-- gwt.lua: bare-repo git worktree workflow for clink (cmd.exe), using native git.
--
-- Companion to the fish function in the nix-config repo (parts/gwt.nix).
-- Same commands on both platforms:
--   gwt              pick a worktree to cd into: fzf picker when fzf is on
--                    PATH, numbered list otherwise (Esc / empty pick cancels)
--   gwt new <branch> create <parent-of-bare-repo>/<branch> and cd into it
--   gwt <branch|path> cd into a worktree (branch name, full path, or path leaf)
--   gwt rm [--force] <branch> remove a worktree (--force is passed
--                              through to git worktree remove)
--   gwt help         print usage (also gwt --help, gwt -h)
--
-- How it works: clink's onfilterinput hook intercepts lines starting with gwt
-- before cmd.exe runs them. The function below calls plain git through
-- io.popen, then returns a replacement command line. For the cd verbs that
-- line is `cd /d "..."`, which cmd.exe executes in the current process, so
-- the directory change sticks. Every other line is replaced by a bare
-- `call`, a cmd.exe no-op, so the gwt line itself is never executed.
--
-- Picker notes: the fzf picker runs
--   fzf --height=40% --no-sort --with-nth=1 < <tempfile>
-- with the worktree list written as branch<TAB>path lines (the same flags
-- and input format as the fish picker; --with-nth=1 keeps the query on the
-- branch column only). The list goes in via a temp file in %TEMP% because
-- clink's io.popen hands the line to cmd.exe (no heredoc) and pipes fzf's
-- stdin. fzf still works despite the piped stdout: its UI talks to the
-- console directly (CONIN$/CONOUT$ on Windows, /dev/tty on Unix), so only
-- the picked line travels back through the pipe. When fzf is not on PATH
-- the command degrades to a numbered list and a blocking stdin read
-- (clink's Lua runtime reads stdin line by line).
--
-- Completion: the file also registers a clink argmatcher, so Tab / Alt-=
-- complete gwt's arguments: the subcommands (new / rm / help, plus
-- --help / -h after a dash) after a bare gwt, local branch names after
-- 'new', worktree branch names plus --force after 'rm', and worktree
-- branch names for the cd form. The candidate functions run git at Tab
-- time, so the branch lists are always current; :nofiles() at every level
-- disables clink's filename fallback for gwt's arguments.
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

-- clink runs on cmd.exe; the POSIX branch exists for the Lua-based tests
local is_windows = package.config:sub(1, 1) == '\\'

-- git's own fatal to the console; suppressed where gwt handles the
-- missing-repo case itself (repo detection, completion)
local errdev = is_windows and ' 2>nul' or ' 2>/dev/null'

-- convert to the path separator the target shell expects: clink's line
-- rewrites run through cmd.exe, which wants backslashes; on any Unix
-- shell the native slash already works (this is also what keeps the
-- script testable off Windows)
local function backslashes(p)
  if is_windows then
    return (p or ''):gsub('/', '\\')
  end
  return p
end

-- dir containing the common git dir, i.e. where the bare repo lives; nil
-- outside a git repo (git's own fatal is suppressed, same as the fish half)
local function repo_parent()
  local out = run('git rev-parse --path-format=absolute --git-common-dir' .. errdev)
  local d = firstline(out)
  if not d then return nil end
  return d:match('^(.*)[/\\][^/\\]+$')
end

-- the line cmd.exe needs to change directory in the current process
local function cd_line(path)
  return 'cd /d "' .. backslashes(path) .. '"', false
end

-- all worktrees as {branch=..., path=...}, in `git worktree list
-- --porcelain` order (branch is nil for a detached HEAD); quiet
-- suppresses git's own fatal (the completion path runs outside repos
-- too; the hook path guards with repo_parent first)
local function worktrees(quiet)
  local wts, cur = {}, nil
  local out = run('git worktree list --porcelain' .. (quiet and errdev or ''))
  for line in out:gmatch('[^\r\n]+') do
    if line:sub(1, 9) == 'worktree ' then
      cur = { branch = nil, path = line:sub(10) }
      wts[#wts + 1] = cur
    elseif line:sub(1, 7) == 'branch ' and cur and not cur.branch then
      cur.branch = line:match('^branch refs/heads/(.+)$')
    end
  end
  return wts
end

-- the pickable worktrees: those with a branch name (detached HEADs stay
-- reachable via `gwt <path>`)
local function branch_worktrees(wts)
  local out = {}
  for _, wt in ipairs(wts) do
    if wt.branch then out[#out + 1] = wt end
  end
  return out
end

-- match by branch name, full path, or path leaf
local function find_worktree(target)
  local pat = target:gsub('%%', '%%%%')
  for _, wt in ipairs(worktrees()) do
    if wt.branch == target or wt.path == target or wt.path:match('[/\\]' .. pat .. '$') then
      return wt.path
    end
  end
  return nil
end

-- path to fzf on PATH, or nil
local function fzf_path()
  local probe = is_windows and 'where fzf 2>nul' or 'command -v fzf'
  local p = firstline(run(probe))
  if p and p ~= '' then
    return p
  end
  return nil
end

-- a scratch file for the picker input, in a place git will never notice:
-- %TEMP% on Windows, $TMPDIR elsewhere (never inside a worktree); the name
-- carries time + a clock fraction so back-to-back picks never collide
local function picker_tmpfile()
  local d, sep
  if is_windows then
    d, sep = os.getenv('TEMP') or os.getenv('TMP') or '.', '\\'
  else
    d, sep = os.getenv('TMPDIR') or '/tmp', '/'
  end
  return d .. sep .. 'gwt-pick-' .. os.time()
    .. '-' .. string.format('%d', (os.clock() % 1) * 1000000) .. '.tmp'
end

-- run fzf over the worktree list; returns the picked worktree's path, or
-- nil when the user cancels (Esc, or Enter on an empty / zero-match
-- selection) or fzf fails to start.
local function fzf_pick(fzf, names)
  local lines = {}
  for i, wt in ipairs(names) do
    lines[i] = wt.branch .. '\t' .. wt.path
  end
  local tmp = picker_tmpfile()
  local f = io.open(tmp, 'w')
  if not f then
    return nil
  end
  f:write(table.concat(lines, '\n') .. '\n')
  f:close()
  local cmd = '"' .. fzf .. '" --height=40% --no-sort --with-nth=1 < "' .. tmp .. '"'
  if is_windows then
    -- CMD /c strips the outermost quotes; preserve the executable and input path quotes.
    cmd = '"' .. cmd .. '"'
  end
  local out = run(cmd)
  os.remove(tmp)
  local sel = firstline(out)
  if not sel then
    return nil
  end
  -- the picked line is the original input line (branch<TAB>path): take
  -- everything after the first tab; if it ever comes back without a tab
  -- (just the branch), resolve it against the list we fed fzf
  local path = sel:match('^[^\t]*\t(.*)$')
  if not path then
    for _, wt in ipairs(names) do
      if wt.branch == sel then
        path = wt.path
        break
      end
    end
  end
  return path
end

-- the fallback picker: a numbered list and a plain line read, mirroring
-- the fish picker's numbered fallback (same prompt, same empty-to-cancel
-- and invalid-number behavior).
local function numbered_pick(names)
  for i, wt in ipairs(names) do
    io.write(('  %d. %s\n'):format(i, wt.branch))
  end
  io.write('pick a worktree (number, empty to cancel): ')
  local pick = (io.read('*l') or ''):gsub('\r$', '')
  if pick == '' then
    return nil
  end
  local k = tonumber(pick:match('^[1-9][0-9]*$') or '')
  if not k or k > #names then
    io.write('gwt: no such choice\n')
    return nil
  end
  return names[k].path
end

-- Usage text: the fish side's text (parts/gwt.nix) with only the
-- platform-specific lines adapted: worktrees live beside the bare repo,
-- not in ~/.worktrees/<repo>/<branch>, and bare gwt always runs a picker
-- (the clink half has no non-interactive mode)
local function help_text()
  local lines = {
    'gwt: bare-repo git worktree workflow',
    '',
    'worktrees live in <parent-of-bare-repo>/<branch>',
    '',
    'usage:',
    '  gwt                pick a worktree to cd into (fzf picker, numbered list without fzf)',
    '  gwt new <branch>   create <parent-of-bare-repo>/<branch> and cd into it',
    '                       (creates the branch from HEAD if it does not exist;',
    '                       initializes submodules -- a failed init warns but the cd still happens)',
    '  gwt <branch|path>  cd into a worktree (branch name, full path, or path leaf)',
    '  gwt rm <branch>    remove a worktree',
    '                       (--force in any position after rm is passed through to git',
    '                       worktree remove, bypassing its dirty-tree and submodule guards)',
  }
  return table.concat(lines, '\n') .. '\n'
end

local function on_gwt(text)
  local args = {}
  for w in text:gmatch('%S+') do args[#args + 1] = w end

  -- help wins over every other verb, as on the fish side; the first
  -- argument alone decides, so `gwt help extra` still prints usage
  if args[2] == 'help' or args[2] == '--help' or args[2] == '-h' then
    io.write(help_text())
    return 'call', false
  end

  if #args == 1 then
    -- interactive picker: fzf when it is on PATH, numbered list otherwise
    if not repo_parent() then
      io.write('gwt: not inside a git repo\n')
      return 'call', false
    end
    local names = branch_worktrees(worktrees())
    if #names == 0 then
      io.write('gwt: no worktrees\n')
      return 'call', false
    end
    local fzf = fzf_path()
    local path
    if fzf then
      path = fzf_pick(fzf, names)
    else
      path = numbered_pick(names)
    end
    if path then
      return cd_line(path)
    end
    -- cancelled: leave the line for the no-op, print nothing
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
      -- check out any submodules in the new worktree; a failure (e.g.
      -- offline) warns, but the cd still happens
      local subout, subcode = run('git -C "' .. backslashes(path) .. '" submodule update --init')
      io.write(subout)
      if subcode ~= 0 then
        io.write('gwt: warning: submodule init failed in ' .. backslashes(path) .. '\n')
      end
      return cd_line(path)
    end
    return 'call', false
  end

  if args[2] == 'rm' then
    -- --force is accepted at any position after rm and passed through to
    -- git worktree remove (bypassing its dirty-tree and submodule
    -- guards); the one remaining arg is the worktree to remove. Extra
    -- non-flag args are ignored (first wins), same as the fish half.
    local force, branch
    for i = 3, #args do
      if args[i] == '--force' then
        force = true
      elseif not branch then
        branch = args[i]
      end
    end
    if not branch then
      io.write('gwt: usage: gwt rm [--force] <branch>\n')
      return 'call', false
    end
    local p = find_worktree(branch)
    if p then
      local out = run('git worktree remove' .. (force and ' --force' or '') .. ' "' .. backslashes(p) .. '"')
      io.write(out)
    else
      io.write('gwt: no worktree matching ' .. branch .. '\n')
    end
    return 'call', false
  end

  local p = find_worktree(args[2])
  if p then
    return cd_line(p)
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

-- =============================================================================
-- Tab / Alt-= completion: a clink argmatcher for gwt
--
-- clink's parser-object argmatcher drives completion for 'gwt ...' lines:
-- linked subparsers ("word"..parser) handle the subcommands, and the
-- per-slot candidate functions run git at Tab time, so the branch lists
-- are always current. Every parser is dead-ended with :nofiles(): without
-- it, clink falls back to filename completion for words past the last
-- argument slot, mixing local files into gwt's arguments (the same
-- failure the fish half fixes with 'complete -c gwt -f').
-- =============================================================================

-- worktree branch names (the cd form and the 'rm' form)
local function worktree_branch_names()
  local out = {}
  for _, wt in ipairs(branch_worktrees(worktrees(true))) do
    out[#out + 1] = wt.branch
  end
  return out
end

-- all local branch names (the candidate source for 'gwt new': existing
-- branches are checked out, missing ones are created)
local function local_branch_names()
  local out = {}
  for line in run('git for-each-ref --format="%(refname:short)" refs/heads' .. errdev):gmatch('[^\r\n]+') do
    out[#out + 1] = line
  end
  return out
end

-- first word after 'gwt': while the user has not typed anything, the
-- candidates are the subcommands themselves -- offered by the parser as
-- the linked words (new / rm / help) plus the --help / -h flags; once the
-- user is typing, the word is a worktree to cd into
local function first_arg_matches(word)
  if word == '' then return {} end
  return worktree_branch_names()
end

-- 'rm' position: the existing worktrees, plus --force (also registered as
-- a flag below so '--f<Tab>' completes to it; the hook consumes it at any
-- position after rm)
local function rm_arg_matches()
  local out = worktree_branch_names()
  out[#out + 1] = '--force'
  return out
end

local help_parser = clink.argmatcher():nofiles()
local new_parser = clink.argmatcher():addarg(local_branch_names):nofiles()
local rm_parser = clink.argmatcher()
  :addflags("--force")
  :addarg(rm_arg_matches)
  :nofiles()

clink.argmatcher("gwt")
  :addflags("--help", "-h")
  :addarg({
    "new" .. new_parser,
    "rm" .. rm_parser,
    "help" .. help_parser,
    first_arg_matches,
  })
  :nofiles()
