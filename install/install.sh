#!/usr/bin/env bash

bash_release=$(bash --version | head -n1 | cut -d ' ' -f4 | cut -d '.' -f1)
[[ $bash_release -ge 4 ]] || {
  # require support of associative array
  echo "require bash 4.0 or higher"
  exit 1
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILE_ROOT="$SCRIPT_DIR"/..
INSTALL_CONF_DIR="$SCRIPT_DIR"/conf
# debug mode is on by default
# don't download nor install packages in debug mode
DEBUG=1
CONFIG_HOME=$HOME/.config
LOCAL_BIN=$HOME/.local/bin
TMP_DIR=$(mktemp -d -t dotfileXXXXX)

declare -A URL
# address mapping
URL["homebrew"]="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
URL["oh-my-zsh"]="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
URL["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
URL["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
URL["vim-plug"]="https://github.com/junegunn/vim-plug"
URL["autojump"]="https://github.com/wting/autojump"
URL["ranger_devicons"]="https://github.com/alexanderjeurissen/ranger_devicons"
URL["ranger_autojump"]="https://github.com/fdw/ranger-autojump"

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
  local question=$1

  echo -n "$question (y/n)? "
  read -r answer
  [[ $answer == "y" ]]
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

cleanup() {
  rm -rf "${TMP_DIR}"
}

########## UTILITY FUNCTIONS END ##########

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
  fmt_msg "Start checking system environment"

  is_macos || (is_linux && is_debian) || {
    fmt_error "Operating system is not supported"
    exit 1
  }

  command_exists git || {
    fmt_error "git is not installed"
    echo "Run 'xcode-select --install' if you are on macOS"
    exit 1
  }

  echo "Checking network connection"
  { ping -q -c 3 -t 5 8.8.8.8 || ping -q -c 3 -W 5 8.8.8.8; } 2>/dev/null || {
    fmt_error "Internet connection failure"
    cat << EOF
WiFi is on?
If so, you are probably behind the Great Firewall.
Turn on your VPN and add the following config in /etc/hosts:

20.205.243.166 github.com
185.199.108.133 raw.githubusercontent.com

You can obtain a valid IP by running:
dig +nostats @8.8.8.8 -t A raw.githubusercontent.com
EOF
    exit 1
  }
}

install_plugin() {
  local plugin=$1
  local target_path=$2
  local target="$target_path/$plugin"

  if ! prompt_user "Install $plugin?"; then return 1; fi

  if [[ -e $target ]]; then
    echo "Already exists. Cleaning $target"
    ((DEBUG)) || rm -rf "$target"
  fi

  ((DEBUG)) || {
    mkdir -p "$target_path" || exit 1
    git -C "$target_path" clone --depth=1 "${URL["$plugin"]}"
  }
}

update_package_manager() {
  fmt_msg "Start updating package manager"

  if is_macos; then
    ((DEBUG)) || {
      # install homebrew
      command_exists brew || bash -c "$(curl -fsSL "${URL["homebrew"]}")"
      brew update
    }
  elif is_debian; then
    ((DEBUG)) || {
        sudo add-apt-repository ppa:aos1/diff-so-fancy
        sudo apt update
    }
  fi
}

get_conf_value() {
  # internal id corresponding to the 1st column of package.conf
  local id=$1
  # target column
  local column=$2

  grep -E "^${id}," "$INSTALL_CONF_DIR"/package.conf 2>/dev/null | cut -d ',' -f "$column"
}

get_package_name() {
  local id=$1

  local column=1
  if is_macos; then
    column=2
  elif is_debian; then
    column=4
  fi

  get_conf_value "$id" "$column"
}

get_bin_name() {
  local id=$1

  local column=1
  if is_macos; then
    column=3
  elif is_debian; then
    column=5
  fi

  get_conf_value "$id" "$column"
}

install_package() {
  # expected command line binary name
  local id=$1

  if [[ $# -eq 1 ]] && ! prompt_user "Install $id?"; then return 1; fi

  local package_name
  package_name=$(get_package_name "$id")

  if [[ -z $package_name ]]; then
    fmt_error "package.conf may be corrupted. Skip installing $id"
    return 1
  fi

  local bin_name
  bin_name=$(get_bin_name "$id")
  if command_exists "$bin_name"; then
    fmt_msg "Skip installing $id: already exists"
    return 0
  fi

  ((DEBUG)) || {
    if is_macos; then
      brew install "$package_name"
    elif is_debian; then
      sudo apt install "$package_name"
    fi

    # add a symlink if command line bin name is not the same as the actual bin name
    [[ "$id" == "$bin_name" ]] || {
      mkdir -p "$LOCAL_BIN" && ln -s -f "$(command -v "$bin_name")" "$LOCAL_BIN/$id"
    }
  }
}

install_omz() {
  if ! prompt_user "Install oh-my-zsh"; then return 1; fi

  local install_path="$CONFIG_HOME"/oh-my-zsh
  local plugin_path="$install_path"/custom/plugins

  ((DEBUG)) || {
    install_package 'zsh' --force
    ZSH="$install_path" bash -c "$(curl -fsSL "${URL["oh-my-zsh"]}")" "" --unattended --keep-zshrc
  }
  # install oh-my-zsh plugins
  local plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
  )
  for plugin in "${plugins[@]}"; do
    install_plugin "$plugin" "$plugin_path"
  done
}

install_vim_plugin_manager() {
  if install_plugin "vim-plug" "$TMP_DIR"; then
    ((DEBUG)) || {
      local target_path="$CONFIG_HOME"/vim/autoload
      mkdir -p "$target_path" && cp "$TMP_DIR"/vim-plug/plug.vim "$target_path"
    }
  fi
}

install_python() {
  install_package 'python3'

  if ! command_exists python; then
    ((DEBUG)) || { mkdir -p "$LOCAL_BIN" && ln -s -f "$(command -v python3)" "$LOCAL_BIN"/python; }
  fi
}

install_pipx() {
  if ! prompt_user "install pipx"; then return 1; fi

  command_exists python3 || {
    fmt_info "Skip installing pipx: python3 is required"
    return 1
  }

  if ((DEBUG)); then return 0; fi

  is_debian && {
    sudo apt install python3-venv
    sudo apt install python3-pip
  }

  python3 -m pip install --upgrade pip
  python3 -m pip install --user pipx

  export PATH=$PATH:$LOCAL_BIN
}

install_autojump() {
  command_exists python3 || {
    fmt_info "Skip installing autojump: python3 is required"
    return 1
  }

  # install autojump (as a requirement to install ranger-autojump plugin)
  # default install path: ~/.autojump
  # autojump has already been included in the plugin list in .zshrc
  if install_plugin "autojump" "$TMP_DIR"; then
    ((DEBUG)) || { cd "$TMP_DIR"/autojump && python3 install.py; }
  fi
}

install_ranger() {
  if ! prompt_user "install ranger"; then return 1; fi

  command_exists pipx || {
    fmt_info "Skip installing ranger: pipx is required"
    return 1
  }

  if ((DEBUG)); then return 0; fi

  # default install path: ~/.local/bin
  pipx install ranger-fm

  ########## install ranger plugin ###########

  local plugin_path="$CONFIG_HOME"/ranger/plugins

  mkdir -p "$plugin_path"

  install_plugin "ranger_devicons" "$plugin_path"

  # to check: ranger-autojump can't be configured as an oh-my-zsh plugin
  install_plugin "ranger_autojump" "$TMP_DIR"
  cp "$TMP_DIR"/ranger-autojump/autojump.py "$plugin_path"
}

install_packages() {

  update_package_manager

  fmt_msg "Start installing software packages"

  install_omz

  install_vim_plugin_manager

  install_python

  install_pipx

  install_autojump

  install_ranger

  local packages=(
    diff-so-fancy
    fd
    fzf
    gpg
    highlight
    htop
    pstree
    rg
    shellcheck
    tmux
    tree
  )

  # force zsh install
  install_package zsh --force

  for package in "${packages[@]}"; do
    install_package "$package"
  done
}

deploy_config() {
  local config=$1

  if [[ $# == 1 ]] && ! prompt_user "Deploy $config config"; then return 1; fi

  ((DEBUG)) || {
    # GNU Stow is a symlink farm manager
    # https://www.gnu.org/software/stow/manual/stow.html
    if ! command_exists stow; then install_package 'stow' --force; fi
    stow --target "$HOME" --dir "$DOTFILE_ROOT" --no-folding "$config" \
      || fmt_info "Deployment failure: remove your old $config config"
  }
}

deploy_configs() {
  fmt_msg "Start deploying config files"

  local configs=(
    git
    gnupg
    ranger
    ssh
    tmux
    vim
  )

  # force zsh config deployment
  local old_zshrc="$HOME"/.zshrc
  [[ -f $old_zshrc || -L $old_zshrc ]] && mv "$old_zshrc" "$HOME"/.zshrc."$(basename "$TMP_DIR")"
  deploy_config zsh --force

  for config in "${configs[@]}"; do
    deploy_config "$config"
  done
}

change_shell() {
  if [[ $(basename -- "$SHELL") != "zsh" ]]; then
    fmt_msg "Switching to zsh"
    ((DEBUG)) || sudo chsh -s /bin/zsh "$USER"
  fi
}

exit_on_signal() {
  fmt_msg "Cleaning up temporary files"
  cleanup
}

main() {
  validate_parameter "$@"

  check_env

  install_packages

  deploy_configs

  change_shell

  fmt_msg "Finish. Run 'exit' and re-login"
}

trap exit_on_signal EXIT

main "$@"
