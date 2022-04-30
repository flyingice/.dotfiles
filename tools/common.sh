#!/usr/bin/env bash

PACKAGES=(
    bat
    diff-so-fancy
    fd
    fzf
    gpg
    htop
    lazygit
    pstree
    rg
    shellcheck
    tmux
    tree
)

CONFIGS=(
    bat
    ideavim
    git
    gnupg
    ranger
    ripgrep
    ssh
    tmux
    vim
    zsh
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

