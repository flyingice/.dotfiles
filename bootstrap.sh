#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

prompt_user() {
    echo -n "(y/n)? "
    read -r answer
    [[ "$answer" == "y" ]]
}

prepare_dir() {
    path=$1

    echo "Cleaning $path ..."
    rm -rf "$path"
    mkdir -p "$path"
}

install_plugin() {
    from=$1
    to=$2
    if [[ -e "$to" ]]; then
        git -C "$to" clone --depth=1 "$from"
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
        install_plugin "https://github.com/preservim/nerdtree" "$mandatory"
        install_plugin "https://github.com/mileszs/ack.vim.git" "$mandatory"
    fi

    echo -n "Would you like to install optional vim plugins? "
    if prompt_user; then
        prepare_dir "$optional"
        install_plugin "https://github.com/joshdick/onedark.vim" "$optional"
        install_plugin "https://github.com/vim-airline/vim-airline" "$optional"
        install_plugin "https://github.com/vim-airline/vim-airline-themes" "$optional"
    fi
}

install_zsh_plugin() {
    echo -n "Would you like to install oh-my-zsh? "
    if prompt_user; then
        echo "Run 'exit' when oh-my-zsh installation is completed."
        # install oh-my-zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        # install oh-my-zsh plugins
        to="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"
        prepare_dir "$to"
        install_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "$to"
        install_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$to"
    fi
}

install_fonts() {
    echo -n "Would you like to install power fonts? "
    if prompt_user; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install fonts-powerline
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            git clone --depth=1 https://github.com/powerline/fonts.git
            cd fonts && ./install.sh
            cd .. && rm -rf fonts
        fi
    fi
}

install_config() {
    config=$1

    echo -n "Would you like to install $config (y/n)? "
    read -r answer
    if [[ "$answer" != "y" ]]; then
        return
    fi

    if [[ -e "${HOME}/$config" ]]; then
        echo -n "$config already exists. Do you want to overwrite it (y/n)? "
        read -r answer
        if [[ "$answer" != "y" ]]; then
            echo "Skip installing $config"
            return
        fi
    fi

    ln -s -f "${SCRIPT_DIR}/$config" ~
}

do_on_macos() {
    # install homebrew
    if [[ ! $(/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)") ]]; then
        exit 1
    fi

    # MacOS defaults to zsh from Catalina and later versions,
    # thus no need to install zsh
}

do_on_linux() {
    # install zsh
    if [[ ! $(sudo apt-get install zsh) ]]; then
        exit 1
    fi
}

change_shell() {
    if [[ $(basename -- "$SHELL") != "zsh" ]]; then
        echo "Switching shell to zsh ..."
        sudo chsh -s /bin/zsh "$USER"
    fi
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    do_on_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    do_on_macos
else
    echo "Operating system is not supported."
    exit 1
fi

# install oh-my-zsh and its plugins
install_zsh_plugin

# install vim plugins
install_vim_plugin

# install powerline fonts
install_fonts

# install config files
configs=(.zshrc
    .vimrc .vimrc.ext
    .tmux.conf .tmux-status-bar.conf
    .ackrc)
for config in "${configs[@]}"; do
    install_config "$config"
done

change_shell

echo "Finish. Please exit and then log in."
