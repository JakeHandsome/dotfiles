# gwt: git worktree workflow

`gwt` is a small wrapper around plain `git` for the bare-repo worktree
layout: `git clone --bare` a repo, then keep every working tree as a
sibling of the bare repo. One command creates a tree and lands you in it;
one name gets you back.

The same commands exist on both platforms, so the workflow is learned once:

```
gwt                list worktrees
gwt new <branch>   create <parent-of-bare-repo>/<branch>, then cd into it
                   (the branch is created from HEAD if it does not exist)
gwt <branch|path>  cd into a worktree (branch name, full path, or path leaf)
gwt rm <branch>    remove a worktree
```

Examples, with `~/dev/repo.git` as the bare clone:

```
cd ~/dev/repo.git
gwt new feature-x      # creates ~/dev/feature-x, now standing in it
gwt feature-x          # later: back in ~/dev/feature-x
gwt rm feature-x       # done with it
```

A branch with a slash (`new feature/auth`) creates a nested directory
(`feature/auth`), the same on both platforms.

## Windows (this script)

`gwt.lua` (this directory) is a clink extension: it intercepts `gwt ...`
lines in `cmd.exe` before they run, does the git work through `io.popen`,
and replaces the line with `cd /d "..."` when a directory change is the
point. That `cd` runs in your own cmd.exe process, so it sticks. A normal
executable can never do that, which is the whole reason the clink trick
exists.

Setup, once:

1. Install clink: `winget install --id chrisant996.Clink -e` (scoop works
   too). Make sure it autoruns in cmd.exe, or `clink inject` into an
   already-open window.
2. This directory is your clink profile via a junction (see `link.bat`):
   `sudo mklink /d %LOCALAPPDATA%\clink %CD%`. With the junction in place
   the script is already installed, nothing else to do.
3. `git` on PATH, 2.31 or newer for `--path-format=absolute` (any recent
   Git for Windows qualifies).

No aliases, environment variables, or config files. `gwt` only exists in
clink-injected cmd windows.

### Notes and limits

- Discovery works from the bare repo directory or from any worktree of
  that repo; both resolve to the same `git rev-parse
  --path-format=absolute --git-common-dir`.
- Git's own error output goes straight to the console (clink's `io.popen`
  only captures stdout), so a failed `gwt new` fails visibly and does not
  change directory.
- There is no interactive picker here. The filter runs commands through
  `io.popen`, which has no TTY, and interactive pickers need one. clink's
  own Ctrl+Space list can stand in for one if you add a match generator.
- `gwt rm` passes through git's guard: a dirty worktree is refused unless
  you add git's own `--force` (the script does not forward extra flags;
  say so in an issue to your own dotfiles if you need it).

### Optional: Tab completion

clink match generators can feed worktree branch names into completions;
see the "Match generators" section of the clink docs
(https://chrisant996.github.io/clink/clink.html). Not set up here.

## Linux (fish, via home-manager)

The twin is a fish function defined in the nix-config flake at
`parts/gwt.nix` (`programs.fish.functions`, so it lands in
`~/.config/fish/functions/`), no file to install. Same commands, same
placement rule, but a fish function runs inside your shell so `cd` is a
plain `cd` and no line-rewrite is needed. The only shared dependency is
`git` itself.

## Where this came from

Research notes on the workflow and the tool landscape (gtr, k1LoW/git-wt,
shhac/git-wt, zoxide's mechanism) live in the nix-config repo at
`docs/research/git-worktree-workflow.md`. The cd mechanism here follows
clink-zoxide's `onfilterinput` pattern, which this directory also carries
(`zoxide.lua`).
