#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# bash version is required > 4.0
declare -A addr
# address mapping
addr["homebrew"]="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
addr["oh-my-zsh"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
addr["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
addr["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
addr["nerdtree"]="https://github.com/preservim/nerdtree"
addr["ack.vim"]="https://github.com/mileszs/ack.vim"
addr["vim-surround"]="https://github.com/tpope/vim-surround"
addr["commentary"]="https://tpope.io/vim/commentary"
addr["onedark.vim"]="https://github.com/joshdick/onedark.vim"
addr["vim-colors-xcode"]="https://github.com/arzg/vim-colors-xcode"
addr["vim-airline"]="https://github.com/vim-airline/vim-airline"
addr["vim-airline-themes"]="https://github.com/vim-airline/vim-airline-themes"

prompt_user() {
    echo -n "(y/n)? "
    read -r answer
    [[ $answer == "y" ]]
}

prepare_dir() {
    path=$1

    echo "Cleaning $path ..."
    rm -rf "$path"
    mkdir -p "$path"
}

install_plugin() {
    plugin=$1
    to=$2
    if [[ -e $to ]]; then
        git -C "$to" clone --depth=1 "${addr["$plugin"]}"
    fi
}

install_vim_plugin() {
    # Autoload packages must be installed to ~/.vim/pack/*/start
    mandatory="$HOME/.vim/pack/plugins/start"
    # Packages in ~/.vim/pack/*/opt can be loaded on the fly
    optional="$HOME/.vim/pack/plugins/opt"

    echo -n "Would you like to install recommended vim plugins? "
    if prompt_user; then
        prepare_dir "$mandatory"
        install_plugin "nerdtree" "$mandatory"
        install_plugin "ack.vim" "$mandatory"
        install_plugin "vim-surround" "$mandatory"
        install_plugin "commentary" "$mandatory"
    fi

    echo -n "Would you like to install optional vim plugins? "
    if prompt_user; then
        prepare_dir "$optional"
        install_plugin "onedark.vim" "$optional"
        install_plugin "vim-colors-xcode" "$optional"
        install_plugin "vim-airline" "$optional"
        install_plugin "vim-airline-themes" "$optional"
    fi
}

install_zsh_plugin() {
    echo -n "Would you like to install oh-my-zsh? "
    if prompt_user; then
        echo "Run 'exit' when oh-my-zsh installation is completed."
        # install oh-my-zsh
        /bin/bash -c "$(curl -fsSL "${addr["oh-my-zsh"]}")"

        # install oh-my-zsh plugins
        to="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"
        prepare_dir "$to"
        install_plugin "zsh-syntax-highlighting" "$to"
        install_plugin "zsh-autosuggestions" "$to"
    fi
}

install_config() {
    config=$1

    echo -n "Would you like to install $config (y/n)? "
    read -r answer
    if [[ $answer != "y" ]]; then
        return
    fi

    if [[ -e ${HOME}/$config ]]; then
        echo -n "$config already exists. Do you want to overwrite it (y/n)? "
        read -r answer
        if [[ $answer != "y" ]]; then
            echo "Skip installing $config"
            return
        fi
    fi

    ln -s -f "${SCRIPT_DIR}/$config" ~
}

do_on_macos() {
    # install homebrew
    /bin/bash -c "$(curl -fsSL "${addr["homebrew"]}")"

    # MacOS defaults to zsh from Catalina and later versions,
    # thus no need to install zsh
}

do_on_linux() {
    # debian-derived distro
    if grep -qi 'debian' /etc/os-release ; then
        sudo apt-get install zsh
    fi
}

change_shell() {
    if [[ $(basename -- "$SHELL") != "zsh" ]]; then
        echo "Switching shell to zsh ..."
        sudo chsh -s /bin/zsh "$USER"
    fi
}

if [[ $OSTYPE == "linux-gnu"* ]]; then
    do_on_linux
elif [[ $OSTYPE == "darwin"* ]]; then
    do_on_macos
else
    echo "Operating system is not supported."
    exit 1
fi

# install oh-my-zsh and its plugins
install_zsh_plugin

# install vim plugins
install_vim_plugin

# install config files
configs=(.zshrc
    .vimrc .vimrc.ext
    .tmux.conf .tmux.conf.local
    .ackrc)
for config in "${configs[@]}"; do
    install_config "$config"
done

change_shell

echo "Finish. Please exit and then log in."
