"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/


" The file contains settings of plugins bundled with vim

filetype plugin on

" ====
" ==== matchit
" ====

" load matchit so that % command can jump between matching pair of keywords
runtime macros/matchit.vim

" ====
" ==== netrw
" ====

" default on tree view
" hit i key to cycle through view types
let g:netrw_liststyle = 3
" default width of the directory explorer
let g:netrw_winsize = 25
" key bindings
nnoremap <A-t> :Vexplore<CR>
