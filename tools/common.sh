#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
INSTALL_CONF_DIR="$SCRIPT_DIR"/conf

CONFIG_HOME=$HOME/.config
LOCAL_BIN=$HOME/.local/bin

PACKAGES=(
    bat
    diff-so-fancy
    fd
    fzf
    gpg
    htop
    lazygit
    nvim
    pstree
    rg
    shellcheck
    tmux
    tree
    zsh
)

CONFIGS=(
    bat
    git
    gpg
    ideavim
    nvim
    ranger
    rg
    tmux
    vim
)

FMT_RED=$(printf '\033[31m')
FMT_GREEN=$(printf '\033[32m')
FMT_YELLOW=$(printf '\033[33m')
FMT_BOLD=$(printf '\033[1m')
FMT_RESET=$(printf '\033[0m')

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
  local file=/etc/os-release
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

backup_file() {
  local old=$1
  local new=$2

  [[ -e $old ]] && mv "$old" "$new"
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
