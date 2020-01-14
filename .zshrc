source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git

export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
antigen bundle lukechilds/zsh-nvm

antigen bundle node
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme avit

# Tell Antigen that you're done.
antigen apply

alias gpr="git pull --rebase"
alias vim="nvim"
#export PATH="$HOME/.fastlane/bin:/usr/local/bin/:$PATH"
#export PATH=$PATH:/usr/local/opt/sbt/bin
export GIT_EDITOR=nvim

source ~/.profile
