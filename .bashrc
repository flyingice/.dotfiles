# terminal colors
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# dev
DEV_HOME=$HOME/Dev

# c/cpp
CPP_STD='c++17'
alias clang++="clang++ -std=$CPP_STD -Wall -g"
alias g++="g++ -std=$CPP_STD -Wall -g"

# golang was set up via brew install
# set golang working dir to overwite the default path
export GOPATH=$DEV_HOME/golang-public
# prevent go test from caching the results
export GOCACHE=off

# python
alias python='python3'

# common utilities
alias ls='ls -GFh'
