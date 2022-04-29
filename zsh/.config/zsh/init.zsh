[[ ${PATH#*$HOME/.local/bin} == $PATH ]] && export PATH=$PATH:$HOME/.local/bin

# ====
# ==== system-wide default settings
# ====

# set for programs that follow the XDG base directory specification
export XDG_CONFIG_HOME=$CONFIG_HOME

export EDITOR=vim

export PAGER=less

# ====
# ==== history settings
# ====

# set non-default .zsh_history location
export HISTFILE=$CONFIG_HOME_ZSH/zsh-history
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
export VIMINIT="source $CONFIG_HOME/vim/vimrc"

# ====
# ==== command-line fuzzy finder
# ====

FD_PROMPT='1. fd> '
RG_PROMPT='2. rg> '

# https://github.com/junegunn/fzf
export FZF_DEFAULT_COMMAND='fd --hidden --follow --type file --exclude .git'
export FZF_DEFAULT_OPTS="--prompt '$FD_PROMPT' --height 40% --layout=reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --line-range=:100 {}'"

# ====
# ==== ripgrep
# ====

export RIPGREP_CONFIG_PATH=$CONFIG_HOME/ripgrep/ripgreprc

# ====
# ==== bat
# ====

export BAT_CONFIG_PATH=$CONFIG_HOME/bat/bat.conf

# ====
# ==== GnuPG
# ====

# set non-default gpg config location
export GNUPGHOME=$CONFIG_HOME/gnupg
