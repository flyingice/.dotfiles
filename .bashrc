# dev root
DEV_HOME=$HOME/Dev

# c/cpp
CPP_STD='c++17'
alias clang++="clang++ -std=$CPP_STD -Wall -g"
alias g++="g++ -std=$CPP_STD -Wall -g"

# golang was set up via Homebrew
# set golang working dir to overwite the default path
export GOPATH=$DEV_HOME/golang-public
# prevent go test from caching the results
# export GOCACHE=off

# python
alias python='python3'

# cheatsheet edit
export CHEAT_EDITOR=vim
export CHEATCOLORS=true

