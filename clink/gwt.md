# gwt: git worktree workflow

`gwt` is a small wrapper around plain `git` for the bare-repo worktree
layout: `git clone --bare` a repo, and do all the work in linked
worktrees. One command creates a tree and lands you in it; one name
gets you back.

The same commands exist on both platforms, so the workflow is learned
once. The halves differ in where new worktrees go (the fish half under
`~/.worktrees/<repo>/`, the clink half as siblings of the bare repo)
and in the details of bare `gwt` (below). Run `gwt` from the bare repo
directory or from any worktree of that repo; both resolve to the same
common git directory.

## Usage

`gwt help` (also `gwt --help`, `gwt -h`) prints the usage text. The two
halves differ in exactly three lines — where worktrees live and the
bare-`gwt` picker — and the block below renders those lines with two
placeholders:

- `<placement>`: `~/.worktrees/<repo>/<branch>` (fish),
  `<parent-of-bare-repo>/<branch>` (clink)
- `<picker>`: `plain list when non-interactive` (fish),
  `fzf picker, numbered list without fzf` (clink)

```
gwt: bare-repo git worktree workflow

worktrees live in <placement>

usage:
  gwt                pick a worktree to cd into (<picker>)
  gwt new <branch>   create <placement> and cd into it
                       (creates the branch from HEAD if it does not exist;
                       initializes submodules -- a failed init warns but the cd still happens)
  gwt <branch|path>  cd into a worktree (branch name, full path, or path leaf)
  gwt rm <branch>    remove a worktree
                       (--force in any position after rm is passed through to git
                       worktree remove, bypassing its dirty-tree and submodule guards)
```

## Bare gwt (no arguments)

Bare `gwt` opens the fzf picker on both halves when `fzf` is on PATH:
the same flags (`fzf --height=40% --no-sort --with-nth=1`) and the
same input format (`branch<TAB>path` lines, with `--with-nth=1`
keeping the query on the branch column only). A pick cds into the
picked worktree; Esc, or Enter on a zero-match selection, cancels: no
directory change, no error.

Without `fzf` on PATH, both halves fall back to a numbered list and a
plain `pick a worktree (number, empty to cancel)` prompt. An empty
pick cancels; a pick that is not a number in range is refused with
`gwt: no such choice`.

Fish half only: a non-interactive shell (a script, `fish -c`) prints a
plain `git worktree list` instead of opening a picker and returns.

Clink half only: interactive-only by construction. The hook sees lines
typed at a clink-injected cmd.exe prompt and nothing else — there is
no `gwt` executable for a script to call.

Both halves, at the edges of interactive use: outside a git repo,
`gwt: not inside a git repo`; a repo with no worktrees, `gwt: no
worktrees`.

## gwt new <branch>

Creates the worktree at `<placement>` and cds into it. An existing
branch is checked out; a missing one is created from HEAD. Both halves
then run `git submodule update --init` in the new worktree; a failure
(e.g. offline) warns `gwt: warning: submodule init failed in <path>`,
but the cd still happens. A failed `git worktree add` itself prints
git's own error, and gwt does not cd.

A branch with a slash (`gwt new feature/auth`) creates a nested
directory (`feature/auth`) on both halves.

## gwt <branch|path>

Cds into the worktree whose branch name, full path, or path leaf
matches the argument. No match: `gwt: no worktree matching <arg>`.

## gwt rm <branch>

Runs plain `git worktree remove`, so git's own guards surface as-is: a
dirty worktree, a worktree with initialized submodules, and a locked
worktree are all refused. `--force` at any position after `rm` is
passed through to `git worktree remove --force`, which bypasses those
guards — on a dirty worktree it discards uncommitted work without a
prompt. No branch argument: `gwt: usage: gwt rm [--force] <branch>`;
no match: `gwt: no worktree matching <arg>`.

Do not `gwt rm` the worktree you are standing in: the removal succeeds
and you are left in a deleted directory. `cd` out first.

## Examples

Windows (clink half), with `C:\dev\repo.git` as the bare clone:

```
C:\dev\repo.git> gwt new feature-x
C:\dev\feature-x> gwt feature-x
C:\dev\feature-x> gwt rm feature-x
```

`gwt new feature-x` creates `C:\dev\feature-x` beside the bare repo
and lands in it; `gwt feature-x` gets you back later; `gwt rm
feature-x` removes it. The fish half runs the same three commands
against `~/dev/repo.git` and creates `~/.worktrees/repo/feature-x`
instead.

## Windows (this script)

`gwt.lua` (this directory) is a clink extension: it intercepts `gwt
...` lines in `cmd.exe` before they run, does the git work through
`io.popen`, and replaces the line with `cd /d "..."` when a directory
change is the point. Every other gwt line is replaced by a bare
`call`, a cmd.exe no-op, so the gwt line itself is never executed.
That `cd` runs in your own cmd.exe process, so it sticks. A normal
executable can never do that, which is the whole reason the clink
trick exists. clink 1.x supports cmd.exe only — there is no PowerShell
mode.

Setup, once:

1. Install clink: `winget install --id chrisant996.Clink -e` (scoop
   works too). Make sure it autoruns in cmd.exe, or `clink inject`
   into an already-open window.
2. This directory is your clink profile via a junction (see
   `link.bat`): `sudo mklink /d %LOCALAPPDATA%\clink %CD%`. With the
   junction in place the script is already installed, nothing else to
   do.
3. `git` on PATH, 2.31 or newer for `--path-format=absolute` (any
   recent Git for Windows qualifies).

No aliases, environment variables, or config files. `gwt` only exists
in clink-injected cmd windows.

### Notes and limits

- Git's own error output goes straight to the console (clink's
  `io.popen` only captures stdout), so a failed `gwt new` fails
  visibly and does not change directory.
- The fzf picker runs inside clink's piped subprocess: the worktree
  list reaches fzf through a temp file in %TEMP% (clink's `io.popen`
  hands the line to cmd.exe, which has no heredoc, and pipes the
  child's stdin); it is removed after the pick. Piped stdout is no
  obstacle to the UI: fzf talks to the console directly (CONIN$/CONOUT$
  on Windows), so only the picked line travels back through the pipe.
  (This mechanism is what clink-fzf, the official fzf-for-clink
  integration, relies on as well.)

### Tab completion

`gwt.lua` registers a clink argmatcher, so Tab (and Alt-= for the list)
complete gwt's arguments: the subcommands (`new`, `rm`, `help`;
`--help` and `-h` after typing `-`) after a bare `gwt`, local branch
names after `gwt new`, worktree branch names plus `--force` after
`gwt rm`, and worktree branch names for the bare-`gwt` cd form.
Clink's filename fallback is disabled for gwt's arguments. The branch
lists are generated by git at Tab time, so they are always current.

## Linux (fish, via home-manager)

The twin is a fish function defined in the nix-config flake at
`parts/gwt.nix` (`programs.fish.functions`, so it lands in
`~/.config/fish/functions/`), no file to install. A fish function runs
inside your shell, so `cd` is a plain `cd` and no line-rewrite is
needed.

Worktrees go to `~/.worktrees/<repo>/<branch>`, where `<repo>` is the
bare repo's directory name minus a trailing `.git`; a non-bare
checkout is handled the same way (its common dir is `<repo>/.git`).
Bare `gwt` behaves as described above: the same fzf flags and input
format as the clink half, the same numbered fallback, and a plain
`git worktree list` in a non-interactive shell.

Tab completion comes from `programs.fish.completions` in the same
module: the subcommands after a bare `gwt`, worktree branch names for
the cd form, local branch names after `gwt new`, and worktree branch
names plus `--force` after `gwt rm`, with the filename fallback
disabled (`complete -c gwt -f`).

The only required dependency is `git`; `fzf` is optional and only
needed for the picker.

## Platform notes

- fzf availability: optional on both halves. On PATH, bare `gwt` is
  the picker; off it, the numbered fallback (plus the plain list on
  the fish half in non-interactive shells). The Windows host has it
  via winget, and this directory's `clink_settings` pins
  `fzf.exe_location` for clink's own fzf bindings.
- Where each half lives: the fish half is the function in
  `parts/gwt.nix` of the nix-config flake, installed by home-manager;
  the clink half is `gwt.lua` in this directory, installed via the
  `%LOCALAPPDATA%\clink` junction.
- Worktree placement: `~/.worktrees/<repo>/<branch>` on the fish
  half, a sibling of the bare repo on the clink half. The commands
  and the workflow are otherwise identical.

## Where this came from

Research notes on the workflow and the tool landscape (gtr, k1LoW/git-wt,
shhac/git-wt, zoxide's mechanism) live in the nix-config repo at
`docs/research/git-worktree-workflow.md`. The cd mechanism here follows
clink-zoxide's `onfilterinput` pattern, which this directory also carries
(`zoxide.lua`).
