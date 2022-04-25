[[ ${PATH#*"$HOME"/.local/bin} == "$PATH" ]] && export PATH=$HOME/.local/bin:$PATH

# ====
# ==== system-wide default settings
# ====

export EDITOR=vim

export PAGER=less

# ====
# ==== history settings
# ====

# set non-default .zsh_history location
export HISTFILE=$XDG_CONFIG_HOME/zsh/zsh-history
# remove copies in the history list while keeping the newly added one
setopt HIST_IGNORE_ALL_DUPS
# don't save duplicated lines more than once whatever options are set
setopt HIST_SAVE_NO_DUPS
# don't store history or fc command
setopt HIST_NO_STORE
# don't store function definitions
setopt HIST_NO_FUNCTIONS

# ====
# ==== vim
# ====

# set non-default .vimrc location
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

# ====
# ==== command-line fuzzy finder
# ====

# https://github.com/junegunn/fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 50% --reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ====
# ==== GnuPG
# ====

# set non-default gpg config location
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
# Let gpg-agent communicate with ssh-agent so that the auth subkey
# managed by gnupg can be used during ssh authentification.
# The exact key used is specified by the keygrip in ~/.gnupg/sshcontrol
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# Fix error 'gpg failed to sign the data', refer to man page of gpg-agent
export GPG_TTY="$(tty)"
