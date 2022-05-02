#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILE_ROOT="$SCRIPT_DIR"/..

# shellcheck disable=SC1091
source "$SCRIPT_DIR"/common.sh

DEBUG=1

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

uninstall_config() {
  local config=$1

  if can_skip "$config" || { [[ $# == 1 ]] && ! prompt_user "Uninstall $config config"; }; then return 1; fi

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

uninstall_configs() {
  fmt_msg "Start uninstalling config files"

  uninstall_zsh_config

  for config in "${CONFIGS[@]}"; do
    uninstall_config "$config"
  done
}

main() {
  validate_parameter "$@"

  uninstall_configs

  fmt_msg "Finish. Run 'exit' and re-login"
}

main "$@"
