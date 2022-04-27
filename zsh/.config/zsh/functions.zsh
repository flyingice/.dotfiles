# In case of error "SSH sever accepts key, but signing fails", consider run
# `gpg-connect-agent updatestartuptty /bye`
# `man gpg-agent` for more details
gpg_restart() {
    gpgconf --kill gpg-agent
    gpg-agent --daemon
}

# function wrapper making parent shell switches to the ranger working dir when ranger exits
# Check ranger macros on https://github.com/ranger/ranger/wiki/Official-user-guide
# Check ranger integrations on https://github.com/ranger/ranger/wiki/Integration-with-other-programs
ra() {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t ranger.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    "${ranger_cmd[@]}" "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n "$(pwd)")" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

# function to generate .vimrc for IntelliJ IdeaVim plugin
# ideavim can not recogonize `runtime` command in .vimrc following the vim config split
ideavim_update() {
    local config_path="$CONFIG_HOME"/vim
    local config_list=(
        "$config_path"/settings.vim
        "$config_path"/functions.vim
        "$config_path"/keymap.vim
        "$config_path"/ideavim.vim
    )

    # concatenate config files with two blank lines as separator
    awk 'FNR==1 && NR>1 { printf("\n\n") } { print $0 }' "${config_list[@]}" > "$HOME"/.ideavimrc
}
