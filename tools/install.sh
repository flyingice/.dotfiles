#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILE_ROOT="$SCRIPT_DIR"/..

source "$SCRIPT_DIR"/common.sh

# debug mode is on by default
# don't download nor install packages in debug mode
DEBUG=1
# default site to download package/plugin
URL='https://github.com'
URL_RAW='https://raw.githubusercontent.com'

TMP_DIR=$(mktemp -d -t dotfileXXXXX)

cleanup() {
  rm -rf "${TMP_DIR}"
}

exit_on_signal() {
  fmt_msg "Cleaning up temporary files"
  cleanup
}

trap exit_on_signal EXIT

parse_argument() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --release)
        DEBUG=0
        shift
      ;;
      --url)
        URL="$2"
        shift
        shift
      ;;
      --url-raw)
        URL_RAW="$2"
        shift
        shift
      ;;
      *)
        fmt_error "Illegal parameters. Usage: install.sh \
[--release] [--url https://hub.fastgit.xyz] [--url-raw https://raw.fastgit.org]"
        exit 1
      ;;
    esac
  done

  if ((DEBUG)); then
    fmt_info "MODE DEBUG"
  else
    fmt_info "MODE RELEASE"
  fi
}

check_requirement() {
  fmt_msg "Start checking system requirement"

  is_macos || (is_linux && is_debian) || {
    fmt_error "Operating system is not supported"
    exit 1
  }

  command_exists git || {
    fmt_error "git is not installed"
    echo "Run 'xcode-select --install' if you are on macOS"
    exit 1
  }

  {
    echo "Start checking network connection"
    if is_macos; then
      ping -q -c 3 -t 5 8.8.8.8
    else
      ping -q -c 3 -W 5 8.8.8.8
    fi
  } 2>/dev/null || {
    fmt_error "Internet connection failure"
    cat << EOF
WiFi is on?
If so, you are probably behind the Great Firewall.
Turn on your VPN and add the following config in /etc/hosts:

20.205.243.166 github.com
185.199.108.133 raw.githubusercontent.com

You can obtain a valid IP by running:
dig +nostats @8.8.8.8 -t A raw.githubusercontent.com

Alternatively, you can specify --url and --url-raw options to
designate a mirror site of github. e.g.:

install.sh --release --url https://hub.fastgit.xyz --url-raw https://raw.fastgit.org
EOF
    exit 1
  }
}

setup_env() {
  fmt_msg "Start setting up environment"

  ((DEBUG)) || {
    export PATH=$PATH:$LOCAL_BIN

    mkdir -p "$CONFIG_HOME" || exit 1
    mkdir -p "$DATA_HOME" || exit 1
    mkdir -p "$LOCAL_BIN" || exit 1
  }
}

install_plugin() {
  local plugin=$1
  local target_path=$2

  if [[ $# -eq 2 ]] && ! prompt_user "Install $(basename "$plugin")?"; then return 1; fi

  local target
  target="$target_path/$(basename "$plugin")"
  if [[ -e $target ]]; then
    echo "Already exists. Cleaning $target"
    ((DEBUG)) || rm -rf "$target"
  fi

  ((DEBUG)) || {
    mkdir -p "$target_path" || exit 1
    git -C "$target_path" clone --depth=1 "$URL/$plugin"
  }
}

update_package_manager() {
  fmt_msg "Start updating package manager"

  if is_macos; then
    ((DEBUG)) || {
      # install homebrew
      command_exists brew || bash -c "$(curl -fsSL "$URL_RAW"/Homebrew/install/HEAD/install.sh)"
      brew update
    }
  elif is_debian; then
    ((DEBUG)) || {
        sudo add-apt-repository ppa:aos1/diff-so-fancy
        sudo add-apt-repository ppa:lazygit-team/release
        sudo apt update
    }
  fi
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

    # add a symlink if the expected cmd bin name (1st column of package.conf) is not the same as the actual bin name
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
    REMOTE="$URL"/ohmyzsh/ohmyzsh ZSH="$install_path" bash -c \
      "$(curl -fsSL "$URL_RAW"/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended --keep-zshrc
  }
  # install oh-my-zsh plugins
  local plugins=(
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
  )
  for plugin in "${plugins[@]}"; do
    install_plugin "$plugin" "$plugin_path"
  done
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
}

install_autojump() {
  command_exists python3 || {
    fmt_info "Skip installing autojump: python3 is required"
    return 1
  }

  # install autojump (as a requirement to install ranger-autojump plugin)
  # default install path: ~/.autojump
  # autojump has already been included in the plugin list in .zshrc
  if install_plugin "flyingice/autojump" "$TMP_DIR"; then
    ((DEBUG)) || { cd "$TMP_DIR"/autojump && python3 install.py --destdir "$HOME"/.local ; }
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

  install_plugin "alexanderjeurissen/ranger_devicons" "$plugin_path"

  # to check: ranger-autojump can't be configured as an oh-my-zsh plugin
  install_plugin "fdw/ranger-autojump" "$TMP_DIR" && \
    cp "$TMP_DIR"/ranger-autojump/autojump.py "$plugin_path"
}

install_node() {
  if ! prompt_user "install nodejs"; then return 1; fi

  if ((DEBUG)); then return 0; fi

  export NVM_DIR="$DATA_HOME/nvm"

  if is_macos; then
    brew install nvm
    # load nvm
    [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
  else
    install_plugin "nvm-sh/nvm" "$DATA_HOME" --force && source "$NVM_DIR/nvm.sh"
  fi

  mkdir -p "$NVM_DIR" && nvm install --lts
}

install_packages() {

  update_package_manager

  fmt_msg "Start installing software packages"

  install_omz

  install_python

  install_pipx

  install_autojump

  install_ranger

  install_node

  for package in "${PACKAGES[@]}"; do
    install_package "$package"
  done
}

deploy_config() {
  local config=$1

  if can_skip "$config" ||  { [[ $# == 1 ]] && ! prompt_user "Deploy $config config"; }; then return 1; fi

  ((DEBUG)) || {
    # GNU Stow is a symlink farm manager
    # https://www.gnu.org/software/stow/manual/stow.html
    if ! command_exists stow; then install_package 'stow' --force; fi
    stow --target "$CONFIG_HOME" --dir "$DOTFILE_ROOT" --override='.*' --no-folding "$config" \
      || fmt_info "Deployment failure: remove your old $config config"
  }
}

deploy_zsh_config() {
  if ! prompt_user "Deploy zsh config"; then return 1; fi

  # successful deployment of zsh config is critical
  # rename ~/.zshenv if it exists as it will cause conflict when invoking stow
  ((DEBUG)) || {
    backup_file "$HOME"/.zshenv "$HOME/.zshenv.$$"

    cat > "$HOME"/.zshenv << EOF
if [[ -d ${XDG_CONFIG_HOME:-$HOME/.config}/zsh ]]; then
    export ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh
fi
EOF

    deploy_config 'zsh' --force
  }
}

deploy_nvim_config() {
  if ! prompt_user "Deploy nvim config"; then return 1; fi

  ((DEBUG)) || {
    deploy_config 'nvim' --force

    # patch url in plugin config
    if is_macos; then
      find "$DOTFILE_ROOT/nvim" -type f -name plugins.lua \
        -exec sed -i '' "s;'https://github.com';'""$URL""';g" {} \;
    elif is_linux; then
      find "$DOTFILE_ROOT/nvim" -type f -name plugins.lua \
        -exec sed -i "s;'https://github.com';'""$URL""';g" {} \;
    fi
  }
}

deploy_configs() {
  fmt_msg "Start deploying config files"

  deploy_zsh_config

  deploy_nvim_config

  for config in "${CONFIGS[@]}"; do
    deploy_config "$config"
  done
}

change_shell() {
  if [[ $(basename -- "$SHELL") != "zsh" ]]; then
    fmt_msg "Switching to zsh"
    ((DEBUG)) || sudo chsh -s /bin/zsh "$USER"
  fi
}

main() {
  parse_argument "$@"

  check_requirement

  setup_env

  install_packages

  deploy_configs

  change_shell

  fmt_msg "Finish. Run 'exit' and re-login"
}

main "$@"
