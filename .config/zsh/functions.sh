# In case of error "SSH sever accepts key, but signing fails", consider run
# `gpg-connect-agent updatestartuptty /bye`
# `man gpg-agent` for more details
gpg_restart() {
  gpgconf --kill gpg-agent
  gpg-agent --daemon
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
    --preview 'line_nb={2}; [[ -z $line_nb ]] && line_nb=1; \
            if command -v bat >/dev/null 2>&1; then bat --highlight-line $line_nb --line-range=:100 {1} ; else cat {1}; fi' |
    IFS=: read -rA selected

  [[ -n ${selected[1]} ]] && "$EDITOR" "${selected[1]}" "+${selected[2]}"
}

# launch lazygit with additional options to facilitate dotfiles management
# https://github.com/jesseduffield/lazygit/issues/778
lg() {
  command lazygit --git-dir="$HOME"/.dotfiles --work-tree="$HOME"
}
