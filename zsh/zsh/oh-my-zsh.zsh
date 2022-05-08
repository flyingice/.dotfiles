# Path to your oh-my-zsh installation.
export ZSH=$CONFIG_HOME/oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"


# Which plugins would you like to load?
# Standard plugins can be found in ~/.config/oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.config/oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  vi-mode
  fzf
  git
  gpg-agent
  zsh-autosuggestions
  zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh


# zsh-autosuggestions plugin accept suggestion
bindkey '`' autosuggest-accept


# modify default fzf key bindings
bindkey -r '^R'
bindkey '^[h' fzf-history-widget

bindkey -r '^T'
bindkey '^[f' fzf-file-widget

bindkey -r '^[c'
bindkey '^[j' fzf-cd-widget
