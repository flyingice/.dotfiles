# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

########################################
# Miscellaneous
########################################

# enable vim mode for command line
bindkey -v

# zsh-autosuggestions plugin accept suggestion
bindkey '`' autosuggest-accept

########################################
# General Shell Settings
########################################

# extend history settings in ~/.oh-my-zsh/lib/history.zsh
# remove copies in the history list while keeping the newly added one
setopt HIST_IGNORE_ALL_DUPS
# don't save duplicated lines more than once whatever options are set
setopt HIST_SAVE_NO_DUPS
# don't store history or fc command
setopt HIST_NO_STORE
# don't store function definitions
setopt HIST_NO_FUNCTIONS

# set system-wide default editor
export EDITOR=vim

# set system-wide default pager
export PAGER=less

########################################
# Utilities
########################################

# fzf settings
# MacOS
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Enable fzf key bindings on debian-derived Linux distro
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
# Enable fzf auto-completion on debian-derived Linux distro
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 50% --reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Let gpg-agent communicate with ssh-agent so that the auth subkey
# managed by gnupg can be used during ssh authentification.
# The exact key used is specified by the keygrip in ~/.gnupg/sshcontrol
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# Fix error 'gpg failed to sign the data', refer to man page of gpg-agent
export GPG_TTY="$(tty)"
# In case of error "SSH sever accepts key, but signing fails", consider run
# `gpg-connect-agent updatestartuptty /bye`
# `man gpg-agent` for more details
gpg_restart() {
    gpgconf --kill gpg-agent
    gpg-agent --daemon
}

# tmux locale settings, otherwise some powerline fonts can't be displayed properly in remote ssh sessions
# solution proposed in https://github.com/wernight/powerline-web-fonts/issues/8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

########################################
# Development Environment
########################################
