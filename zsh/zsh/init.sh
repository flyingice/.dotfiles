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

# set non-default .zsh_history location
export HISTFILE=$DATA_HOME/zsh/zsh-history
# remove copies in the history list while keeping the newly added one
setopt HIST_IGNORE_ALL_DUPS
# don't save duplicated lines more than once whatever options are set
setopt HIST_SAVE_NO_DUPS
# don't store history or fc command
setopt HIST_NO_STORE
# don't store function definitions
setopt HIST_NO_FUNCTIONS

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
# ==== gpg
# ====

# set non-default gpg config location
export GNUPGHOME=$CONFIG_HOME/gpg

# ====
# ==== autojump
# ====

# oh-my-zsh doesn't look in XDG path to find autojump.zsh
# We can safely add autojump entry into omz plugin list and remove settings below after the fix
# https://github.com/flyingice/ohmyzsh/commit/6102bcc49c68da04de40ea1d2d950d87c82f2b5e
# has been merged into omz master branch
autojump_conf=$DATA_HOME/autojump/autojump.zsh
[[ -f $autojump_conf ]] && source "$autojump_conf"

# ====
# ==== lazygit
# ====

# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
# set non-default lazygit config location
export LG_CONFIG_FILE=$CONFIG_HOME/lazygit/config.yml
