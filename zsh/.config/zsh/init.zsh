[[ ${PATH#*$HOME/.local/bin} == $PATH ]] && export PATH=$PATH:$HOME/.local/bin

# ====
# ==== system-wide default settings
# ====

# set for programs that follow XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME=$DATA_HOME
export XDG_CONFIG_HOME=$CONFIG_HOME

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
# ==== man
# ====

# colorize pager for man
export MANPAGER="zsh -c 'col -bx | bat -l man -p'"

# ====
# ==== vim
# ====

# set non-default .vimrc location for vim
# The if condition prevents nvim from loading vim config as it relies on
# $VIMINIT to find user config as well. We don't need to explicitly redirect
# nvim to its config location as it follows XDG specification.
# The downside is vim is not usable anymore on the machine where nvim
# is installed if .vimrc is not under $HOME. A workaround would be to manually
# create a symlink. However, I don't see a reason not to use nvim instead of
# vim if it is already there.
if ! command -v nvim >/dev/null 2>&1; then
    export VIMINIT="source $CONFIG_HOME/vim/vimrc"
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
export FZF_DEFAULT_OPTS="--prompt '$FD_PROMPT' --height 50% --layout=reverse \
    --bind '${SORT_TOGGLE}:toggle-sort' \
    --bind '${PREVIEW_TOGGLE}:toggle-preview' \
    --bind '${PAGE_UP_KEY}:preview-page-up,${PAGE_DOWN_KEY}:preview-page-down'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --line-range=:100 {}'"

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

# oh-my-zsh doesn't look in custom install path to find autojump.zsh
autojump_conf="$HOME"/.local/share/autojump/autojump.zsh
[[ -f $autojump_conf ]] && source "$autojump_conf"
