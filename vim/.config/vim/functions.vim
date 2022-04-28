"  _____                 _   _
" |  ___|   _ _ __   ___| |_(_) ___  _ __  ___
" | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
" |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
" |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/


function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
