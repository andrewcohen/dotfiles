#
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

alias gco='git checkout'
alias grb='git rebase'
alias gs='git status'
alias ga='git add'
alias gd='git diff'

alias ..='cd ..'
alias la='ls -a'
alias ll='ls -al'
alias c='clear'
alias guard='rake db:test:prepare && guard'

function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

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

#export PS1="$(parse_git_branch)\W\$ "

export PS1="[ \W ]$YELLOW\$(parse_git_branch)$GREEN\$ "

export position_in_class="before"
export exclude_tests="true"

#### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
#export PATH=$HOME/local/bin:$PATH
