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

# tmux settings
# don't attach to a tmux session when terminal is launched within IDE
if [[ $TERMINAL_EMULATOR != "JetBrains-JediTerm" ]]; then
    export ZSH_TMUX_AUTOSTART=true
fi
export ZSH_TMUX_CONFIG="$XDG_CONFIG_HOME"/tmux/tmux.conf
export ZSH_TMUX_UNICODE=true
export ZSH_TMUX_DEFAULT_SESSION_NAME='localhost'

# zsh-autosuggestions plugin accept suggestion
bindkey '`' autosuggest-accept

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# enable vim mode for command line
bindkey -v
