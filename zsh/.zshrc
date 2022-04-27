# do not change
CONFIG_HOME=$HOME/.config
CONFIG_HOME_ZSH=$CONFIG_HOME/zsh

source $CONFIG_HOME_ZSH/init.zsh

FILES="$(find -L $CONFIG_HOME_ZSH -type f -name '*.zsh' -not -name 'init.zsh')"
FILE_LIST=($(echo "$FILES" | tr '\n' ' '))

for FILE in $FILE_LIST; do
    source "$FILE"
done
