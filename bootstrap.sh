#!/usr/bin/env bash

bash_release=$(bash --version | head -n1 | cut -d ' ' -f4 | cut -d '.' -f1)
[[ $bash_release -ge 4 ]] || {
  # require support of associative array
  echo "require bash 4.0 or higher"
  exit 1
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# debug mode is on by default
# don't download nor install packages in debug mode
DEBUG=1
LOCAL_BIN=$HOME/.local/bin
TMP_DIR=$HOME/tmp

declare -A URL
# address mapping
URL["homebrew"]="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
URL["oh-my-zsh"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
URL["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
URL["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
URL["nerdtree"]="https://github.com/preservim/nerdtree"
URL["ack.vim"]="https://github.com/mileszs/ack.vim"
URL["vim-surround"]="https://github.com/tpope/vim-surround"
URL["commentary"]="https://tpope.io/vim/commentary"
URL["onedark.vim"]="https://github.com/joshdick/onedark.vim"
URL["vim-colors-xcode"]="https://github.com/arzg/vim-colors-xcode"
URL["vim-airline"]="https://github.com/vim-airline/vim-airline"
URL["vim-airline-themes"]="https://github.com/vim-airline/vim-airline-themes"
URL["ranger_devicons"]="https://github.com/alexanderjeurissen/ranger_devicons"

FMT_RED=$(printf '\033[31m')
FMT_GREEN=$(printf '\033[32m')
FMT_YELLOW=$(printf '\033[33m')
FMT_BOLD=$(printf '\033[1m')
FMT_RESET=$(printf '\033[0m')

########## UTILITY FUNCTIONS BEGIN ##########

fmt_error() {
  printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "${FMT_RESET}" >&2
}

fmt_info() {
  printf '%sInfo: %s%s\n' "${FMT_YELLOW}" "$*" "${FMT_RESET}"
}

fmt_msg() {
  printf '%s%s%s\n' "${FMT_GREEN}" "$*" "${FMT_RESET}"
}

is_macos() {
  [[ $OSTYPE == "darwin"* ]]
}

is_linux() {
  [[ $OSTYPE == "linux-gnu"* ]]
}

is_debian() {
  file=/etc/os-release
  # debian-derived Linux distribution
  [[ -f $file ]] && grep -qi 'debian' /etc/os-release
}

prompt_user() {
  echo -n "(y/n)? "
  read -r answer
  [[ $answer == "y" ]]
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

create_tmp_dir() {
  ((DEBUG)) || [[ -d $TMP_DIR ]] || mkdir -p "$TMP_DIR"
}

clean_tmp_file() {
  ((DEBUG)) || rm -rf "${TMP_DIR:?"Parameter is empty"}"/*
}

########## UTILITY FUNCTIONS END ##########

deploy_config() {
  config=$1

  echo -n "Deploy $config (y/n)? "
  read -r answer
  if [[ $answer != "y" ]]; then return; fi

  if [[ -e $HOME/$config ]]; then
    echo -n "Already exists. Overwrite it (y/n)? "
    read -r answer
    if [[ $answer != "y" ]]; then
      fmt_info "Skip installing $config"
      return
    fi
  fi

  ((DEBUG)) || ln -s -f "${SCRIPT_DIR}/$config" "$HOME"
}

install_plugin() {
  plugin=$1
  to=$2
  target="${to}/${plugin}"

  echo -n "Install ${plugin}? "
  if prompt_user; then
    if [[ -e $target ]]; then
      echo "Already exists. Cleaning $target"
      ((DEBUG)) || rm -rf "$target"
    fi

    ((DEBUG)) || {
      mkdir -p "$to" || exit 1
      git -C "$to" clone --depth=1 "${URL["$plugin"]}"
    }
  fi
}

install_omz() {
  echo -n "Install oh-my-zsh? "
  if prompt_user; then
    ((DEBUG)) || bash -c "$(curl -fsSL "${URL["oh-my-zsh"]}")"

    # install oh-my-zsh plugins
    to="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    plugins=(zsh-syntax-highlighting zsh-autosuggestions)
    for plugin in "${plugins[@]}"; do
      install_plugin "$plugin" "$to"
    done
  fi
}

install_vim_plugin() {
  echo -n "Install vim plugins? "
  if prompt_user; then
    # Autoload packages must be installed to ~/.vim/pack/*/start
    autoload="$HOME/.vim/pack/plugins/start"
    autoload_plugins=(nerdtree ack.vim vim-surround commentary)
    for plugin in "${autoload_plugins[@]}"; do
      install_plugin "$plugin" "$autoload"
    done

    # Packages in ~/.vim/pack/*/opt are loaded on the fly
    optional="$HOME/.vim/pack/plugins/opt"
    optional_plugins=(onedark.vim vim-colors-xcode vim-airline vim-airline-themes)
    for plugin in "${optional_plugins[@]}"; do
      install_plugin "$plugin" "$optional"
    done
  fi
}

validate_parameter() {
  if [[ $# -gt 1 || ($# -eq 1 && $1 != "release") ]]; then
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
  fmt_info "Start checking system environment"

  is_macos || (is_linux && is_debian) || {
    fmt_error "Operating system is not supported"
    exit 1
  }

  command_exists git || {
    fmt_error "git is not installed"
    echo "Run 'xcode-select --install' if you are on macOS"
    exit 1
  }
}

install_basic() {
  fmt_info "Start installing basic tools"

  if is_macos; then
    ((DEBUG)) || {
      if command_exists brew; then
        brew update
      else
        # install homebrew
        bash -c "$(curl -fsSL "${URL["homebrew"]}")"
      fi
      # MacOS defaults to zsh from Catalina and higher versions,
      # thus no need to install zsh
    }
  elif is_debian; then
    ((DEBUG)) || {
      sudo apt update
      # install zsh
      sudo apt install zsh
    }
  fi

  # install oh-my-zsh and its plugins
  install_omz

  # install vim plugins
  install_vim_plugin
}

deploy_config_file() {
  fmt_info "Start deploying config files"

  configs=(.zshrc
    .vimrc .vimrc.ext
    .tmux.conf .tmux.conf.local
    .ackrc)
  for config in "${configs[@]}"; do
    deploy_config "$config"
  done
}

install_python() {
  echo -n "Install python3? "
  if prompt_user; then
    # python3 is installed by default on macOS
    if command_exists python3; then
      fmt_info "Skip installing python3: already exists"
    else
      if isDebian; then
        ((DEBUG)) || sudo apt install python3
      fi
    fi

    if ! command_exists python; then
      ((DEBUG)) || mkdir -p "$LOCAL_BIN" && ln -s -f "$(which python3)" "$LOCAL_BIN"/python
    fi
  fi
}

install_pipx() {
  echo -n "install pipx? "
  if prompt_user; then
    command_exists python3 || {
      fmt_info "Skip installing pipx: python3 is required"
      return
    }

    if ((DEBUG)); then return; fi

    is_debian && {
      sudo apt install python3-venv
      sudo apt install python3-pip
    }

    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
  fi
}

install_autojump() {
  echo -n "install autojump? "
  if prompt_user; then
    command_exists python3 || {
      fmt_info "Skip installing autojump: python3 is required"
      return
    }

    if ((DEBUG)); then return; fi

    # https://github.com/wting/autojump
    # install autojump (as a requirement to install ranger-autojump plugin)
    # default install path: ~/.autojump
    # autojump has already been included in the plugin list in .zshrc
    cd "$TMP_DIR" || exit 1
    git clone --depth=1 https://github.com/wting/autojump
    cd autojump && python3 install.py
  fi
}

install_ranger() {
  echo -n "install ranger? "
  if prompt_user; then
    export PATH=$PATH:$LOCAL_BIN
    command_exists pipx || {
      fmt_info "Skip installing ranger: pipx is required"
      return
    }

    if ((DEBUG)); then return; fi

    # config default path: ~/.config/ranger
    config_path="$HOME/.config/ranger"
    plugin_path="$config_path/plugins"

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
    cd "$TMP_DIR" || exit 1
    git clone --depth=1 https://github.com/fdw/ranger-autojump/
    cp ranger-autojump/autojump.py "$plugin_path"
  fi
}

install_extended() {
  fmt_info "Start installing optional tools"

  # install python as a requisite for other plugins
  install_python
  # install pipx
  install_pipx
  # install autojump
  install_autojump
  # install ranger and its plugins
  install_ranger
}

change_shell() {
  if [[ $(basename -- "$SHELL") != "zsh" ]]; then
    fmt_info "Switching to zsh"
    ((DEBUG)) || sudo chsh -s /bin/zsh "$USER"
  fi
}

exit_on_signal() {
  fmt_error "Execution interrupted"
  clean_tmp_file
  exit 1
}

main() {
  validate_parameter "$@"
  check_env
  create_tmp_dir

  install_basic
  deploy_config_file
  install_extended

  change_shell
  clean_tmp_file
  fmt_msg "Finish. Run 'exit' and re-login"
  exec zsh -l
}

trap exit_on_signal SIGINT SIGTERM

main "$@"
