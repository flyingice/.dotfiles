#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

clean_dir() {
    path=$1
    if [[ -e "$path" ]]; then
        echo "Cleaning $path ..."
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
    echo "Installing $1 under $HOME ..."
    dest="$HOME/$1"
    if [[ -e "$dest" || -L "$dest" ]]; then
        echo -n "$dest already exists. Do you want to overwrite it (yes/no)? "
        read -r answer
        if [[ "$answer" == "yes" ]]; then
            rm -f "$dest"
        else
            echo "Skip installing $1"
            return
        fi
    fi

    ln -s "$SCRIPT_DIR/$1" "$dest"
    echo "Done."
}

# TODO: do_on_macos() has not been tested on a brand new machine
do_on_macos() {
    # install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # note that running homebrew as root is no longer supported
    # install zsh
    brew install zsh

    # install powerline fonts
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts && ./install.sh
    cd .. && rm -rf fonts
}

do_on_linux() {
    sudo apt-get update
    sudo apt-get upgrade

    # install zsh and change login shell
    sudo apt-get install zsh
    sudo chsh -s /bin/zsh "$USER"

    # install powerline fonts
    sudo apt-get install fonts-powerline
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    do_on_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    do_on_maxos
else
    echo "Operating system is not supported."
    exit 1
fi

# install oh-my-zsh
# remove the line 'exec zsh -l' from the install script
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed -E '/^[[:space:]]+exec zsh/ d')"

# install zsh plugins
install_zsh_plugin

# install vim plugins
install_vim_plugin

# install various config files
configs=(.bashrc .zshrc .vimrc .tmux.conf .tmux-status-bar.conf .gitconfig .gitignore_global .git_template)
for config in "${configs[@]}"; do
    install_config "$config"
done

echo "Done. Please exit the session and log in."
