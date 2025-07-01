# zmodload zsh/zprof

# only regenerate compinit once a day
# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

##

# # source /usr/local/share/antigen/antigen.zsh
# source /opt/homebrew/share/antigen/antigen.zsh

# antigen use oh-my-zsh

# # export NVM_LAZY_LOAD=true
# # export NVM_AUTO_USE=true
# # export NVM_NO_USE=true
# antigen bundle lukechilds/zsh-nvm

# antigen bundle git
# antigen bundle node
# antigen bundle jeffreytse/zsh-vi-mode
# # antigen bundle command-not-found
# antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle zsh-users/zsh-completions
# antigen bundle zsh-users/zsh-autosuggestions

# # Load the theme.
# # antigen bundle mafredri/zsh-async
# # antigen bundle sindresorhus/pure@main

# # Tell Antigen that you're done.
# antigen apply

alias gpr="git pull --rebase -p"
alias gc="git commit --verbose"
alias ga="git add"
alias gd="git diff"
alias gst="git status"
alias gco="git checkout"

alias vim="nvim"
with-env() {
  env $(cat .env | grep -v "#" | xargs) $@
}

function tat {
  name=$(basename `pwd` | sed -e 's/\.//g')

  if tmux ls 2>&1 | grep "$name"; then
    tmux attach -t "$name"
  elif [ -f .envrc ]; then
    direnv exec / tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

function lz() {
  if tmux list-windows | grep -q 'lazygit'; then
    tmux select-window -t lazygit
  else
    tmux new-window -n lazygit -c "#{pane_current_path}" lazygit
  fi
}


function curl_time() {
    curl -so /dev/null -w "\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

#export PATH="$HOME/.fastlane/bin:/usr/local/bin/:$PATH"
#export PATH=$PATH:/usr/local/opt/sbt/bin
export GIT_EDITOR=nvim
export EDITOR=nvim
export ZVM_VI_EDITOR=nvim

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# no idea why these are broken in tmux 3
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward

source ~/.profile

# zprof

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
eval "$(/opt/homebrew/bin/mise activate zsh)"

source <(COMPLETE=zsh jj)

