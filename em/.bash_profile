export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin
export CC=/usr/bin/gcc-4.2

export EDITOR=vim

. /usr/bin/z.sh

source ~/.git-completion.bash
alias secrets='cat ~/.secrets/clients-credentials.txt ~/.secrets/credentials.txt'

alias guard='rake db:test:prepare && guard'

alias gco='git checkout'
alias grb='git rebase'
alias gs='git status'
alias ga='git add'
alias gd='git diff'

alias ..='cd ..'
alias la='ls -a'
alias ll='ls -al'
alias c='clear'

function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

function view_skel {
  mkdir $1
  (cd $1 && touch index.html.erb && touch new.html.erb && touch edit.html.erb && touch show.html.erb)
}

#commit changes and get args as message
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

export PS1="[ \W ]$YELLOW\$(parse_git_branch)$GREEN\$ "

fortune | cowthink -f stegosaurus
export PATH=/usr/local/sbin:/Users/andrewcohen/.rvm/gems/ruby-1.9.3-p392@ford_models/bin:/Users/andrewcohen/.rvm/gems/ruby-1.9.3-p392@global/bin:/Users/andrewcohen/.rvm/rubies/ruby-1.9.3-p392/bin:/Users/andrewcohen/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
