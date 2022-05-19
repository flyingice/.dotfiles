"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/
"
" Author: @flyingice

filetype plugin on

" load plugins bundled with vim
" extended % matching
packadd! matchit

" ====
" ==== vim-plug
" ====

" install vim-plug for first-time users
if empty(glob($HOME.'/.config/vim/autoload/plug.vim'))
  silent !curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif

" following plugins are added primarily for ideavim emulation purpose
call plug#begin("~/.config/vim/plugged")

" https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

" https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" https://github.com/tpope/vim-commentary
Plug 'tpope/vim-commentary'

" https://github.com/vim-scripts/argtextobj.vim
Plug 'vim-scripts/argtextobj.vim'

call plug#end()
