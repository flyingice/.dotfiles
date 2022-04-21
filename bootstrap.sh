#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

FMT_RED=$(printf '\033[31m')
FMT_YELLOW=$(printf '\033[33m')
FMT_BOLD=$(printf '\033[1m')
FMT_RESET=$(printf '\033[0m')

# debug mode is on by default
# don't download nor install packages in debug mode
DEBUG=1
# whether python3 is available on the system
# it is a pre-requisite to install some plugins
PYTHON3_AVAILABLE=0

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
addr["ranger_devicons"]="https://github.com/alexanderjeurissen/ranger_devicons"

prompt_user() {
  echo -n "(y/n)? "
  read -r answer
  [[ $answer == "y" ]]
}

# path must be under user's home to pass the check
# fail the check by default
validate_path() {
  path=${1:-"/"}

  [[ $path == ${HOME}* ]] || exit 1
}

install_plugin() {
  plugin=$1
  to=$2
  target="${to}/${plugin}"

  echo -n "install ${plugin}? "
  if prompt_user; then
      if (( DEBUG )); then return; fi

      if [[ -e $target ]]; then
          validate_path "$target"
          fmt_info "Already exists. Cleaning $target ..."
          rm -rf "$target"
      fi

      mkdir -p "$to" || exit 1
      git -C "$to" clone --depth=1 "${addr["$plugin"]}"
  fi
}

install_vim_plugin() {
  # Autoload packages must be installed to ~/.vim/pack/*/start
  mandatory="$HOME/.vim/pack/plugins/start"
  # Packages in ~/.vim/pack/*/opt can be loaded on the fly
  optional="$HOME/.vim/pack/plugins/opt"

  echo "Start installing recommended vim plugins ..."
  install_plugin "nerdtree" "$mandatory"
  install_plugin "ack.vim" "$mandatory"
  install_plugin "vim-surround" "$mandatory"
  install_plugin "commentary" "$mandatory"

  echo "Start installing optional vim plugins ..."
  install_plugin "onedark.vim" "$optional"
  install_plugin "vim-colors-xcode" "$optional"
  install_plugin "vim-airline" "$optional"
  install_plugin "vim-airline-themes" "$optional"
}

install_omz() {
  echo -n "Install oh-my-zsh? "
  if prompt_user; then
      echo "Run 'exit' when oh-my-zsh installation is completed."

      if (( DEBUG )); then return; fi

      # install oh-my-zsh
      /bin/bash -c "$(curl -fsSL "${addr["oh-my-zsh"]}")"

      # install oh-my-zsh plugins
      to="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"
      install_plugin "zsh-syntax-highlighting" "$to"
      install_plugin "zsh-autosuggestions" "$to"
  fi
}

install_config() {
  config=$1

  echo -n "Install $config (y/n)? "
  read -r answer
  if [[ $answer != "y" ]]; then
      return
  fi

  if [[ -e ${HOME}/$config ]]; then
      fmt_info -n "Already exists. Overwrite it (y/n)? "
      read -r answer
      if [[ $answer != "y" ]]; then
          echo "Skip installing $config"
          return
      fi
  fi

  if (( DEBUG )); then return; fi

  ln -s -f "${SCRIPT_DIR}/$config" ~
}

check_requirement() {
  if command_exists python3; then PYTHON3_AVAILABLE=1; fi
}

do_on_macos() {
  if (( DEBUG )); then return; fi

  # install homebrew
  /bin/bash -c "$(curl -fsSL "${addr["homebrew"]}")"

  # MacOS defaults to zsh from Catalina and later versions,
  # thus no need to install zsh

  if (( PYTHON3_AVAILABLE )); then
      python3 -m pip install --user pipx
      python3 -m pipx ensurepath
  fi
}

do_on_linux() {
  if (( DEBUG )); then return; fi

  # debian-derived distro
  if grep -qi 'debian' /etc/os-release ; then
      # install zsh
      sudo apt install zsh

      # install pipx as a prerequisite to install ranger
      if (( PYTHON3_AVAILABLE )); then
          python3 -m pip install --user pipx
          python3 -m pipx ensurepath
          sudo apt install python3-venv
      fi
  fi
}

change_shell() {
  if (( DEBUG )); then return; fi

  if [[ $(basename -- "$SHELL") != "zsh" ]]; then
      echo "Switching to zsh ..."
      sudo chsh -s /bin/zsh "$USER"
  fi
}

validate_parameter() {
  if [[ $# -gt 1  || ( $# -eq 1 && $1 != "release") ]]; then
      fmt_error "Illegal parameters. Usage: $0 [release]"
      exit 1
  fi

  if [[ $# -eq 1 ]]; then
      DEBUG=0
  fi

  if (( DEBUG )); then
      fmt_info "MODE DEBUG"
  else
      fmt_info "MODE RELEASE"
  fi
}

install_ranger() {
  # config default path: ~/.config/ranger
  config_path="${HOME}/.config/ranger"
  plugin_path="${config_path}/plugins"

  echo -n "install ranger? "
  if prompt_user; then
      if (( DEBUG || PYTHON3_AVAILABLE == 0 )); then return; fi

      mkdir -p "$config_path" "$plugin_path"

      # https://github.com/ranger/ranger
      # default install path: ~/.local/bin
      pipx install ranger-fm

      # You can generate default config via 'ranger --copy-config=all'
      cp "${SCRIPT_DIR}/ranger/rc.conf" "$config_path"

      ########## install ranger plugin ###########

      # https://github.com/alexanderjeurissen/ranger_devicons
      install_plugin "ranger_devicons" "$plugin_path"

      # https://github.com/wting/autojump
      # install autojump (as a requirement to install ranger-autojump plugin)
      # default install path: ~/.autojump
      # autojump has already been included in the plugin list in .zshrc
      git clone --depth=1 https://github.com/wting/autojump
      cd autojump && python3 install.py
      cd .. && rm -rf autojump

      # https://github.com/fdw/ranger-autojump
      # ranger-autojump can't be configured as a omz plugin for unknown reason
      git clone --depth=1 https://github.com/fdw/ranger-autojump
      cp ranger-autojump/autojump.py "$plugin_path"
      rm -rf ranger-autojump
  fi
}

install_common() {
  # install oh-my-zsh and its plugins
  install_omz

  # install vim plugins
  install_vim_plugin

  # install ranger and its plugins
  install_ranger

  # install config files
  configs=(.zshrc
      .vimrc .vimrc.ext
      .tmux.conf .tmux.conf.local
      .ackrc)
  for config in "${configs[@]}"; do
      install_config "$config"
  done
}

fmt_error() {
  printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "${FMT_RESET}" >&2
}

fmt_info() {
  printf '%sInfo: %s%s\n' "${FMT_YELLOW}" "$*" "${FMT_RESET}"
}

command_exists() {
  command -v "$@" >/dev/null 2>&1;
}

install_platform_dependent() {
  if [[ $OSTYPE == "linux-gnu"* ]]; then
      do_on_linux
  elif [[ $OSTYPE == "darwin"* ]]; then
      do_on_macos
  else
      fmt_error "Operating system is not supported."
      exit 1
  fi
}

validate_parameter "$@"
check_requirement
install_platform_dependent
install_common
change_shell

echo "Finish. Please exit and then log in."
