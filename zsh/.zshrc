# do not change
DATA_HOME=$HOME/.local/share
CONFIG_HOME=$HOME/.config
CACHE_HOME=$HOME/.cache

CONFIG_HOME_ZSH=$CONFIG_HOME/zsh

FILES="$(find -L $CONFIG_HOME_ZSH -type f -name '*.zsh' -not -name 'init.zsh')"
FILE_LIST=($(echo "$FILES" | tr '\n' ' '))

source $CONFIG_HOME_ZSH/init.zsh

for FILE in $FILE_LIST; do
    source "$FILE"
done
