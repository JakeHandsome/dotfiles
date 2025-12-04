# Dotfiles
This repo is config files for some programs I use, below is some notes on setup and purpose

## Wezterm https://github.com/wezterm/wezterm
   - Modern terminal emulator with multiplex features built in (no need for tmux)
   - [Settings](.config/wezterm/wezterm.lua)

## Clink https://github.com/chrisant996/clink
  - Modern shell for windows, makes using the terminal for finding files or autocompetions easy
  - Settings
    - clink set exec_match_style -1
      - This lets you autocomplete any file for executables. Allowing you do to `start sln<tab>` and have it auto complete to `start Dune-ADC-Code.sln` which lets me open visual studio from command line (Works for any file type)
    - Clink completions https://github.com/vladimir-kotikov/clink-completions
      - Adds more completions, importart for git operations

## Starship https://github.com/starship/starship
  - Terminal prompt, gives information related to project right in your shell
  - Settings
    - Clink integration
    - [starship.lua](clink/starship.lua)

## Zoxide https://github.com/ajeetdsouza/zoxide
  - Smarter cd command, lets you type partial paths and fuzzy find previously visited directories
  - Settings
    - Clink integration
    - [Link](clink/zoxide.lua)

## uutils/coreutils https://github.com/uutils/coreutils
  - Rewrite of GNU coreutils in rust, works for windows. Use the same commands on linux and windows
  - Settings
    - Clink aliases
    - [Link](clink/clink_start.cmd##L5-L7)

## ripgrep (rg) https://github.com/BurntSushi/ripgrep
  - Super fast grep

## fd https://github.com/sharkdp/fd
  - Super fast file find

## neovim
  - Best editor
  - Settings (These are personal and you should probably write your own, A good started config is called LazyVim)
    - [Link](nvim)

## Kanata https://github.com/jtroo/kanata/
  - Tool for software remapping of keys, I remap CAPSLOCK to ESC to make ESC more reachable
  - [Settings](caps2esc.kbd)

## gsudo https://github.com/gerardog/gsudo
  - Adds sudo to windows, its nice, need to make sure to overwrite the default windows 11 sudo
  - Troubleshooting in win11 https://gerardog.github.io/gsudo/docs/gsudo-vs-sudo#what-if-i-install-both

## bat https://github.com/sharkdp/bat
  - Upgraded cat command, provide some pretty printing and git context when used

## difftastic https://github.com/Wilfred/difftastic
  - Better terminal diff tool (My default git diff command, gitdifftool goes to beyond compare)

