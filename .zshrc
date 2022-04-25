[[ ${PATH#*$HOME/.local/bin} == $PATH ]] && export PATH=$HOME/.local/bin:$PATH

export XDG_CONFIG_HOME=~/.config

# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME"/oh-my-zsh

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
plugins=(tmux git fzf autojump zsh-autosuggestions zsh-syntax-highlighting)

# fzf settings
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 50% --reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_CONFIG="$XDG_CONFIG_HOME"/tmux/tmux.conf
export ZSH_TMUX_UNICODE=true
export ZSH_TMUX_DEFAULT_SESSION_NAME='localhost'

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

# vim settings
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
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

# function wrapper making parent shell switches to the ranger working dir when ranger exits
# Check ranger macros on https://github.com/ranger/ranger/wiki/Official-user-guide
# Check ranger integrations on https://github.com/ranger/ranger/wiki/Integration-with-other-programs
function ra() {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t ranger.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

# function to generate .vimrc for IntelliJ IdeaVim plugin
# ideavim can not recogonize `runtime` command in .vimrc following the vim config split
function ideavim_update() {
    local config_path=$XDG_CONFIG_HOME/vim
    local config_list=(
        "$config_path"/settings.vim
        "$config_path"/functions.vim
        "$config_path"/keymap.vim
        "$config_path"/ideavim.vim
    )

    # concatenate config files with two blank lines as separator
    awk 'FNR==1 && NR>1 { printf("\n\n") } { print $0 }' "${config_list[@]}" > ~/.ideavimrc
}

########################################
# Development Environment
########################################

# Go
export GOPATH=~/go
[[ ${PATH#*$GOPATH/bin} == $PATH ]] && export PATH=$GOPATH/bin:$PATH
