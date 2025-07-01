# Fish shell configuration
# Converted from .zshrc

# Git aliases using abbreviations (expand when typed)
abbr -a gpr 'git pull --rebase -p'
abbr -a gc 'git commit --verbose'
abbr -a ga 'git add'
abbr -a gd 'git diff'
abbr -a gst 'git status'
abbr -a gco 'git checkout'

# Other aliases
abbr -a vim 'nvim'
abbr -a tf 'terraform'
abbr -a k 'kubectl'

# Environment variables
set -gx GIT_EDITOR nvim
set -gx EDITOR nvim
set -gx ZVM_VI_EDITOR nvim
set -gx GOPATH ~/go

# Add paths
fish_add_path $GOPATH/bin

# Key bindings (Fish uses different syntax)
bind \ca beginning-of-line
bind \ce end-of-line
bind \cr history-search-backward

# Functions
function git-cleanup-old-branches --description "Clean up old Git branches that have been deleted on remote"
    git fetch --prune
    and git branch --delete (git for-each-ref --format '%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)' refs/heads/ | string split ' ')
end

# function with-env --description "Run command with environment variables from .env file"
#     if test -f .env
#         env (cat .env | grep -v "#" | string replace -r '^' '' | string replace -r '=' ' ') $argv
#     else
#         echo "No .env file found in current directory"
#         return 1
#     end
# end

function with-env --description "Run command with environment variables from .env file"
    if test -f .env
        set -l env_vars
        for line in (cat .env)
            # Skip comments and empty lines
            if string match -q "#*" $line; or test -z "$line"
                continue
            end
            # Ensure line has an '=' and is in KEY=VALUE format
            if string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- $line
                set env_vars $env_vars $line
            end
        end
        env $env_vars $argv
    else
        echo "No .env file found in current directory"
        return 1
    end
end

function tat --description "Tmux attach or create session based on directory name"
    set name (basename (pwd) | sed -e 's/\.//g')

    if tmux ls 2>&1 | grep -q "$name"
        tmux attach -t "$name"
    else if test -f .envrc
        direnv exec / tmux new-session -s "$name"
    else
        tmux new-session -s "$name"
    end
end

function lz --description "Open lazygit in tmux window"
    if tmux list-windows | grep -q 'lazygit'
        tmux select-window -t lazygit
    else
        tmux new-window -n lazygit -c "#{pane_current_path}" lazygit
    end
end

function curl_time --description "Show detailed timing information for curl requests"
    curl -so /dev/null -w "\
     namelookup:  %{time_namelookup}s\n\
        connect:  %{time_connect}s\n\
     appconnect:  %{time_appconnect}s\n\
    pretransfer:  %{time_pretransfer}s\n\
       redirect:  %{time_redirect}s\n\
  starttransfer:  %{time_starttransfer}s\n\
  -------------------------\n\
          total:  %{time_total}s\n" $argv
end

# Source profile if it exists
if test -f ~/.profile
    source ~/.profile
end

# # Initialize tools
# if command -q starship
#     starship init fish | source
# end

if command -q mise
    mise activate fish | source
end

if command -q kubectl
  kubectl completion fish | source
end

if type -q fzf
  fzf --fish | source
  # Fish 4 syntax for ctrl-r history search
  bind \cr fzf-history-widget
end

# Jujutsu completion
if command -q jj
    jj util completion fish | source
end

# Bun completions
if test -d ~/.bun
    set -gx BUN_INSTALL ~/.bun
    fish_add_path $BUN_INSTALL/bin
end

# rustup shell setup
if not contains "$HOME/.cargo/bin" $PATH
    # Prepending path in case a system-installed rustc needs to be overridden
    set -x PATH "$HOME/.cargo/bin" $PATH
end

set --global hydro_multiline true
set -U fish_greeting

# opam configuration
source /Users/acohen/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
