[[ ${PATH#*$HOME/.local/bin} == "$PATH" ]] && export PATH=$PATH:$HOME/.local/bin

# ====
# ==== system-wide default settings
# ====

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

export PAGER=less

# ====
# ==== history settings
# ====

# set non-default zsh history location
export HISTFILE=$CONFIG_HOME/zsh/.zsh_history
# remove copies in the history list while keeping the newly added one
setopt HIST_IGNORE_ALL_DUPS
# don't save duplicated lines more than once whatever options are set
setopt HIST_SAVE_NO_DUPS
# don't store history or fc command
setopt HIST_NO_STORE
# don't store function definitions
setopt HIST_NO_FUNCTIONS
# don't store trivial commands
HISTORY_IGNORE="(cat *|cd|cd *|cp *|dot *|echo *|export *|la|la *|lazygit|lg|ll|ll *|ls|ls *|mkdir *|mv *|nvim|nvim *|pwd|rm *|sudo *|touch *|which *|exit)"
# don't store failed commands, --help or --version lookups
zshaddhistory() {
    whence ${${(z)1}[1]} >| /dev/null || return 1
    [[ $1 == *--help* || $1 == *--version* ]] && return 1
}

# ====
# ==== less
# ====

# disable default history file in $HOME/.lesshst
export LESSHISTFILE=-

# ====
# ==== man
# ====

# colorize pager for man
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="zsh -c 'col -bx | bat -l man -p'"
fi

# ====
# ==== vim
# ====

# set non-default .vimrc location for vim
# The if condition prevents nvim from loading vim config as it relies on
# $VIMINIT to find user config as well. We don't need to explicitly redirect
# nvim to its config location as it follows XDG specification.
# The downside is we can't open vim with proper settings anymore on a machine
# where nvim is installed if .vimrc is not under $HOME.
# By removing the if condition, nvim can share the same config with vim
if ! command -v nvim >/dev/null 2>&1; then
  export VIMINIT="set runtimepath+=$CONFIG_HOME/vim | source $CONFIG_HOME/vim/vimrc"
fi

# ====
# ==== command-line fuzzy finder
# ====

# https://github.com/junegunn/fzf
FD_PROMPT='1. fd> '
RG_PROMPT='2. rg> '

SORT_TOGGLE='ctrl-s'
PREVIEW_TOGGLE='ctrl-/'
PAGE_UP_KEY='ctrl-b'
PAGE_DOWN_KEY='ctrl-f'

export FZF_DEFAULT_COMMAND='fd --hidden --follow --type file --exclude .git'
export FZF_DEFAULT_OPTS="--prompt '$FD_PROMPT' --height 60% --layout=reverse \
    --preview-window 'right,50%,border-rounded' \
    --bind '${SORT_TOGGLE}:toggle-sort' \
    --bind '${PREVIEW_TOGGLE}:toggle-preview' \
    --bind '${PAGE_UP_KEY}:preview-page-up,${PAGE_DOWN_KEY}:preview-page-down'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview \
    'if command -v bat >/dev/null 2>&1; then bat --line-range=:100 {}; else cat {}; fi'"

# ====
# ==== rg
# ====

# https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
# rg doesn't look in any predetermined directory for a config
export RIPGREP_CONFIG_PATH=$CONFIG_HOME/rg/ripgreprc

# ====
# ==== bat
# ====

# https://github.com/sharkdp/bat#configuration-file
# set non-default config location
export BAT_CONFIG_PATH=$CONFIG_HOME/bat/bat.conf

# ====
# ==== lazygit
# ====

# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
# set non-default lazygit config location
export LG_CONFIG_FILE=$CONFIG_HOME/lazygit/config.yml

# ====
# ==== nvm
# ====
export NVM_DIR=$DATA_HOME/nvm

# ====
# ==== Obsidian
# ====
export PATH=$PATH:/Applications/Obsidian.app/Contents/MacOS
