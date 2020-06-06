#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

clean_dir() {
    path=$1
    if [[ -e "$path" ]]; then
        echo "cleaning $path ..."
        rm -rf "$path"
    fi
    mkdir -p "$path" || exit 1
}

install_plugin() {
    origin=$1
    dest=$2
    git -C "$dest" clone "$origin"
}

install_vim_plugin() {
    dest="$HOME/.vim/pack/vendor/start"

    clean_dir "$dest"

    install_plugin "https://github.com/joshdick/onedark.vim" "$dest"
    install_plugin "https://github.com/vim-airline/vim-airline" "$dest"
    install_plugin "https://github.com/vim-airline/vim-airline-themes" "$dest"
    install_plugin "https://github.com/preservim/nerdtree" "$dest"
}

install_zsh_plugin() {
    dest="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"

    clean_dir "$dest"

    install_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "$dest"
    install_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$dest"
}

install_config() {
    echo "installing $1 under $HOME..."
    dest="$HOME/$1"
    if [[ -e "$dest" || -L "$dest" ]]; then
        echo -n "$dest already exists. Do you want to overwrite it (yes/no)?"
        read -r answer
        if [[ "$answer" == "yes" ]]; then
            rm -f "$dest"
        else
            echo "skip installing $1"
            return
        fi
    fi

    ln -s "$SCRIPT_DIR/$1" "$dest"
    echo "done"
}

# TODO: detect package manager
# install zsh
sudo apt-get install zsh
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# install zsh plugins
install_zsh_plugin

# install vim plugins
install_vim_plugin

# install various config files
configs=(.bashrc .zshrc .vimrc .tmux.conf .tmux-status-bar.conf .gitconfig)
for config in "${configs[@]}"; do
    install_config "$config"
done
