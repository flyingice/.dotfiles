#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILE_ROOT="$SCRIPT_DIR"/..

source "$SCRIPT_DIR"/common.sh

DEBUG=1

parse_argument() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --release)
        DEBUG=0
        shift
      ;;
      *)
        fmt_error "Illegal parameters. Usage: uninstall.sh [--release]"
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

uninstall_config() {
  local config=$1

  if [[ $# == 1 ]] && ! prompt_user "Uninstall $config config"; then return 1; fi

  command_exists stow || {
    fmt_error "stow is not installed. Your config is probably not installed via install.sh"
    exit 1
  }

  ((DEBUG)) ||  stow --target "$CONFIG_HOME" --dir "$DOTFILE_ROOT" --delete "$config"
}

uninstall_zsh_config() {
  if ! prompt_user "Uninstall zsh config"; then return 1; fi

  ((DEBUG)) || backup_file "$HOME"/.zshenv "$HOME/.zshenv.$$"

  uninstall_config 'zsh' --force
}

uninstall_nvim_config() {
  if ! prompt_user "Uninstall nvim config"; then return 1; fi

  # no need to revert potentially patched plugins.lua
  ((DEBUG)) || uninstall_config 'nvim' --force
}

uninstall_configs() {
  fmt_msg "Start uninstalling config files"

  uninstall_zsh_config

  uninstall_nvim_config

  for config in "${CONFIGS[@]}"; do
    uninstall_config "$config"
  done
}

main() {
  parse_argument "$@"

  uninstall_configs

  fmt_msg "Finish. Run 'exit' and re-login"
}

main "$@"
