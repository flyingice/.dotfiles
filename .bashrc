# terminal colors
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# dev
DEV_HOME=$HOME/Dev

# c/cpp
alias g++='g++ -std=c++17 -Wall -g'

# golang was set up via brew install
# set golang working dir to overwite the default path
export GOPATH=$DEV_HOME/golang-public

# python
alias python='python3'

# common utilities
alias ls='ls -GFh'
