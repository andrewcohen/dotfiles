alias gco='git checkout'
alias grb='git rebase'
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gp='git pull'
alias gpr='git pull --rebase'

alias zs="zeus rspec"
alias zr="zeus rake"

alias ..='cd ..'
alias la='ls -a'
alias ll='ls -al'
alias c='clear'
alias guard='rake db:test:prepare && guard'

alias zake='zeus rake'
alias zspec='zeus rspec'

function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

##commit changes and get args as message
function gg(){
 git commit -m "$*"
}

function parse_git_branch {
  ref=$( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/') || return
  echo ${ref#refs/heads/}
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
RESET="\[\033[0m\]"

export PS1="[ \W ]$YELLOW\$(parse_git_branch)$GREEN\$$RESET "
export EDITOR=vim

# tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
# tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

export position_in_class="before"
export exclude_tests="true"

#### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="/usr/local/sbin:$PATH"
#export PATH=$HOME/local/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source ~/.profile
export PATH=/usr/local/bin:$PATH

eval "$(direnv hook $0)"
alias t='tmux new -s dev'
