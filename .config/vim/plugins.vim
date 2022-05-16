"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/
"
" Author: @flyingice

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

" ====
" ==== vim-plug
" ====

" install vim-plug for first-time users
if empty(glob($HOME.'/.config/vim/autoload/plug.vim'))
  silent !curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif

call plug#begin("~/.config/vim/plugged")

call plug#end()
