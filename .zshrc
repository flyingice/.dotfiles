# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

########################################
# Miscellaneous
########################################

# enable vim mode for command line
bindkey -v

# zsh-autosuggestions plugin accept suggestion
bindkey '^l' autosuggest-accept

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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 50% --reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Let gpg-agent communicate with ssh-agent so that the auth subkey
# managed by gnupg can be used during ssh authentification.
# The exact key used is specified by the keygrip in ~/.gnupg/sshcontrol
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# Fix error 'gpg failed to sign the data', refer to man page of gpg-agent
export GPG_TTY="$(tty)"
gpg_restart() {
    gpgconf --kill gpg-agent
    gpg-agent --daemon
}

# Let homebrew bypass the GFW of China
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:789

# tmux locale settings, otherwise some powerline fonts can't be displayed properly in remote ssh sessions
# solution proposed in https://github.com/wernight/powerline-web-fonts/issues/8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# z utility to jump around
if command -v brew >/dev/null 2>&1;then
    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

########################################
# Development Environment
########################################

# Let gvm manage go versions and GOPATH
# https://github.com/moovweb/gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Required to run jekyll
# Refer to https://docs.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"

# Created by `pipx ensurepath` on 2020-08-04 08:31:45
export PATH="$PATH:$HOME/.local/bin"

# required for pyenv
# refer to step #3 on https://github.com/pyenv/pyenv#basic-github-checkout
# it should be placed toward the end of the shell config since it manipulates PATH
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
# required for pyenv virtualenv plugin
# refer to https://github.com/pyenv/pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then
    eval "$(pyenv virtualenv-init -)";
fi

