export XDG_CONFIG_HOME=~/.config

CONFIG_ROOT=$XDG_CONFIG_HOME/zsh

source $CONFIG_ROOT/init.zsh

FILES="$(find -L $CONFIG_ROOT -type f -name '*.zsh' -not -name 'init.zsh')"
FILE_LIST=($(echo "$FILES" | tr '\n' ' '))

for FILE in $FILE_LIST; do
    source "$FILE"
done
