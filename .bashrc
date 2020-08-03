
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

# locale settings for tmux
# without it, some powerline fonts can't be displayed properly in remote ssh sessions
# solution proposed in https://github.com/wernight/powerline-web-fonts/issues/8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# set default editor for GDB
export EDITOR=$(which vim)

# set system-wide default pager
export PAGER=most

# Let gpg-agent communicate with ssh-agent so that the auth subkey
# managed by gnupg can be used during ssh authentification.
# The exact key used is specified by the keygrip in ~/.gnupg/sshcontrol
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg_restart() {
    gpgconf --kill gpg-agent
    gpg-agent --daemon
}
gpg_restart

# z utility to jump around
. /usr/local/etc/profile.d/z.sh

# fzf default setting
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 50% --reverse"
# apply the command to CTRL-T shorcut
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
