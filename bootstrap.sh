#!/usr/bin/env zsh

SCRIPT_DIR=${0:a:h}
TARGET=('.bashrc' '.zshrc' '.vimrc' '.tmux.conf')

install() {
    echo "installing $1 under $HOME..."
    dest="$HOME/$1"
    if [[ -e "$dest" ]]; then
        echo -n "$dest already exists. Do you want to overwrite it (yes/no)?"
        read answer
        if [[ "$answer" == "yes" ]]; then
            rm -f $dest
        else
            echo "skip installing $1"
            return
        fi
    fi

    ln -s $SCRIPT_DIR/$1 $dest
    echo "done"
}

for config in $TARGET; do
    install $config
done
