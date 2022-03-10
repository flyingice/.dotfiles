# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Key binding
# ctrl+b/f: move word backward/forward
bindkey "^b" backward-word
bindkey "^f" forward-word
# enable vim mode for command line
bindkey -v

########################################
# Personal settings
########################################

# Let gvm manage go versions and GOPATH
# https://github.com/moovweb/gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# locale settings for tmux
# without it, some powerline fonts can't be displayed properly in remote ssh sessions
# solution proposed in https://github.com/wernight/powerline-web-fonts/issues/8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# set system-wide default editor
export EDITOR=vim

# set system-wide default pager
export PAGER=less

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

# z utility to jump around
if command -v brew >/dev/null 2>&1;then
    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# fzf settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 50% --reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Created by `pipx ensurepath` on 2020-08-04 08:31:45
export PATH="$PATH:$HOME/.local/bin"

# Required to run jekyll
# Refer to https://docs.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"

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

# workaround to bypass the GFW of China (added for using homebrew normally)
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:789
