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
    local tempfile
    tempfile="$(mktemp -t ranger.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > $tempfile; quitall"
    )

    "${ranger_cmd[@]}" "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n "$(pwd)")" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

# interactive ripgrep
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode
# check available actions: https://github.com/junegunn/fzf/blob/master/src/options.go
# {q} in the reload command evaluates to the query string on fzf prompt
# alt-f/alt-r to switch between fd and rg mode
irg() {
    local initial_query="${*:-}"
    local fd_command="$FZF_DEFAULT_COMMAND"
    local rg_command='rg --no-heading --color=always'
    local fd_key='alt-f'
    local rg_key='alt-r'

    FZF_DEFAULT_COMMAND="$rg_command $(printf %q "$initial_query")" \
    fzf --ansi \
        --disabled --query "$initial_query" \
        --bind "change:reload:sleep 0.1; $rg_command {q} || true" \
        --bind "${fd_key}:unbind(change,$fd_key)+change-prompt($FD_PROMPT)+enable-search+reload($fd_command)+rebind($rg_key)" \
        --bind "${rg_key}:unbind($rg_key)+change-prompt($RG_PROMPT)+disable-search+reload($rg_command {q} || true)+rebind(change,$fd_key)" \
        --prompt "$RG_PROMPT" \
        --delimiter : \
        --preview 'line_nb={2}; [[ -z $line_nb ]] && line_nb=1; bat --highlight-line $line_nb --line-range=:100 {1}' \
    | IFS=: read -rA selected

    [[ -n ${selected[1]} ]] && vim "${selected[1]}" "+${selected[2]}"
}
