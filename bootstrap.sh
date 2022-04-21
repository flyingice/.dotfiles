#!/usr/bin/env bash

bash_release=$(bash --version | head -n1 | cut -d ' ' -f4 | cut -d '.' -f1)
[[ $bash_release -ge 4 ]] || {
  # require support of associative array
  echo "require bash 4.0 or higher"
  exit 1
}

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

########## utility functions begin ##########

fmt_error() {
  printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "${FMT_RESET}" >&2
}

fmt_info() {
  printf '%sInfo: %s%s\n' "${FMT_YELLOW}" "$*" "${FMT_RESET}"
}

is_MacOS() {
  [[ $OSTYPE == "darwin"* ]]
}

is_Linux() {
  [[ $OSTYPE == "linux-gnu"* ]]
}

is_Debian() {
  # debian-derived distro
  grep -qi 'debian' /etc/os-release
}

prompt_user() {
  echo -n "(y/n)? "
  read -r answer
  [[ $answer == "y" ]]
}

command_exists() {
  command -v "$@" >/dev/null 2>&1;
}

validate_path() {
  # path must be under user's home to pass the check
  # fail the check by default
  path=${1:-"/"}

  [[ $path == ${HOME}* ]] || exit 1
}

########## utility functions end ##########

install_config() {
  config=$1

  echo -n "Install $config (y/n)? "
  read -r answer
  if [[ $answer != "y" ]]; then
      return
  fi

  if [[ -e ${HOME}/$config ]]; then
      echo -n "Already exists. Overwrite it (y/n)? "
      read -r answer
      if [[ $answer != "y" ]]; then
          echo "Skip installing $config"
          return
      fi
  fi

  if (( DEBUG )); then return; fi

  ln -s -f "${SCRIPT_DIR}/$config" ~
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

install_omz() {
  echo -n "Install oh-my-zsh? "
  if prompt_user; then
      if (( DEBUG )); then return; fi

      bash -c "$(curl -fsSL "${addr["oh-my-zsh"]}")"

      # install oh-my-zsh plugins
      to="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"
      install_plugin "zsh-syntax-highlighting" "$to"
      install_plugin "zsh-autosuggestions" "$to"
  fi
}

install_vim_plugin() {
  # Autoload packages must be installed to ~/.vim/pack/*/start
  mandatory="$HOME/.vim/pack/plugins/start"
  # Packages in ~/.vim/pack/*/opt are loaded on the fly
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

validate_parameter() {
  if [[ $# -gt 1  || ( $# -eq 1 && $1 != "release") ]]; then
      fmt_error "Illegal parameters. Usage: $0 [release]"
      exit 1
  fi

  if [[ $# -eq 1 ]]; then
      DEBUG=0
      fmt_info "MODE RELEASE"
  else
      fmt_info "MODE DEBUG"
  fi
}

check_env() {
  is_MacOS || (is_Linux && is_Debian)  || {
    fmt_error "Operating system is not supported."
    exit 1
  }

  command_exists git || {
    fmt_error "git is not installed"
    echo "Run 'xcode-select --install' on MacOS or 'sudo apt install git' on Debian Linux distro"
    exit 1
  }

  if command_exists python3; then PYTHON3_AVAILABLE=1; fi
}

install_basic() {
  if (( DEBUG )); then return; fi

  if is_MacOS; then
    # install homebrew
    bash -c "$(curl -fsSL "${addr["homebrew"]}")"

    # MacOS defaults to zsh from Catalina and later versions,
    # thus no need to install zsh
  elif is_Debian; then
    # install zsh
    sudo apt install zsh
  fi

  # install oh-my-zsh and its plugins
  install_omz

  # install vim plugins
  install_vim_plugin
}

deploy_config_file() {
  if (( DEBUG )); then return; fi

  configs=(.zshrc
      .vimrc .vimrc.ext
      .tmux.conf .tmux.conf.local
      .ackrc)
  for config in "${configs[@]}"; do
      install_config "$config"
  done

  exec zsh -l
}

install_autojump() {
  if (( DEBUG || PYTHON3_AVAILABLE == 0 )); then return; fi

  # https://github.com/wting/autojump
  # install autojump (as a requirement to install ranger-autojump plugin)
  # default install path: ~/.autojump
  # autojump has already been included in the plugin list in .zshrc
  git clone --depth=1 https://github.com/wting/autojump
  cd autojump && python3 install.py
  cd .. && rm -rf autojump
}

install_pipx() {
  if (( DEBUG || PYTHON3_AVAILABLE == 0 )); then return; fi

  python3 -m pip install --user pipx
  python3 -m pipx ensurepath

  is_Debian && {
    sudo apt install python3-venv
  }

  # restart shell to make pipx command immediately available
  exec zsh -l
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

      # https://github.com/fdw/ranger-autojump
      # ranger-autojump can't be configured as an oh-my-zsh plugin for unknown reason
      git clone --depth=1 https://github.com/fdw/ranger-autojump/
      cp ranger-autojump/autojump.py "$plugin_path"
      rm -rf ranger-autojump
  fi
}

install_extended() {
  # install autojump
  install_autojump

  # install pipx as a prerequisite of ranger
  install_pipx

  # install ranger and its plugins
  install_ranger
}

change_shell() {
  if (( DEBUG )); then return; fi

  if [[ $(basename -- "$SHELL") != "zsh" ]]; then
      echo "Switching to zsh ..."
      sudo chsh -s /bin/zsh "$USER"
  fi
}

validate_parameter "$@"
check_env
install_basic
deploy_config_file
change_shell
install_extended

echo "Finish."
