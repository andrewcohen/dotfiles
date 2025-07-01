# Zsh to Fish Migration Guide

## Files Created

- `config.fish` - Main Fish configuration (equivalent to `.zshrc`)
- `functions/` directory with individual function files:
  - `git-cleanup-old-branches.fish`
  - `with-env.fish`
  - `tat.fish`
  - `lz.fish`
  - `curl_time.fish`
- `setup_fish.fish` - Setup script to install the configuration

## Key Changes from Zsh to Fish

### Aliases → Abbreviations
- Zsh: `alias gpr="git pull --rebase -p"`
- Fish: `abbr -a gpr 'git pull --rebase -p'`
- Fish abbreviations expand when you type them (like aliases but show the full command)

### Environment Variables
- Zsh: `export VAR=value`
- Fish: `set -gx VAR value` (global export) or `set -Ux VAR value` (universal)

### Functions
- Fish functions are stored in separate files in `~/.config/fish/functions/`
- Each function gets its own `.fish` file
- More modular and easier to manage

### Key Bindings
- Zsh: `bindkey "^A" beginning-of-line`
- Fish: `bind \ca beginning-of-line`

### Conditionals
- Zsh: `if [ condition ]; then ... fi`
- Fish: `if test condition; ... end`

### Command Substitution
- Zsh: `$(command)` or `command`
- Fish: `(command)`

## Features Not Migrated

The following were commented out in your `.zshrc` and not migrated:
- Antigen plugin manager (use Fisher instead)
- zsh-vi-mode (Fish has built-in vi mode: `fish_vi_key_bindings`)
- Compinit optimizations (Fish handles completions differently)

## Installation Steps

1. Run `chmod +x setup_fish.fish && ./setup_fish.fish`
2. Install Fish: `brew install fish`
3. Install Fisher plugin manager
4. Set Fish as default shell
5. Install recommended plugins (see setup script output)

## Recommended Fish Plugins

- `PatrickF1/fzf.fish` - FZF integration
- `jethrokuan/z` - Directory jumping
- `jorgebucaran/nvm.fish` - Node version management
- `franciscolourenco/done` - Notifications for long-running commands

## Testing

After setup, test your functions:
- `git-cleanup-old-branches`
- `with-env echo test`
- `tat` (if you have tmux)
- `curl_time google.com`