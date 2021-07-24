# zmodload zsh/zprof

# only regenerate compinit once a day
# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C
##

source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
export NVM_NO_USE=true
antigen bundle lukechilds/zsh-nvm

antigen bundle git
antigen bundle node
antigen bundle jeffreytse/zsh-vi-mode
# antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

# Tell Antigen that you're done.
antigen apply

alias gpr="git pull --rebase -p"
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

#export PATH="$HOME/.fastlane/bin:/usr/local/bin/:$PATH"
#export PATH=$PATH:/usr/local/opt/sbt/bin
export GIT_EDITOR=nvim
export ZVM_VI_EDITOR=nvim

source ~/.profile

# zprof

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

