# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
DATA_HOME=$HOME/.local/share
CONFIG_HOME=$HOME/.config
CACHE_HOME=$$HOME/.cache

FILES="$(find -L $CONFIG_HOME/zsh -type f -name '*.zsh' -not -name 'init.zsh')"
FILE_LIST=($(echo "$FILES" | tr '\n' ' '))

source $CONFIG_HOME/zsh/init.zsh

for FILE in $FILE_LIST; do
    source "$FILE"
done
