"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/


" ====
" ==== vim-plug
" ====

" install vim-plug for first-time users
if empty(glob($HOME.'/.config/vim/autoload/plug.vim'))
    silent !curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
endif

call plug#begin("~/.config/vim/plugged")

" enhance netrw shipped with vim
Plug 'tpope/vim-vinegar'

" provide mapping to easily delete, change and add surroudings in paris
Plug 'tpope/vim-surround'

" comment out the target of a motion
Plug 'tpope/vim-commentary'

" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" change cursor shape in different vim modes
Plug 'jszakmeister/vim-togglecursor'

" nice statusline at the bottom of each vim window
Plug 'vim-airline/vim-airline'
" theme for vim-airline
Plug 'vim-airline/vim-airline-themes'

" colorscheme
Plug 'joshdick/onedark.vim'
Plug 'arzg/vim-colors-xcode'

" Initialize plugin system
call plug#end()

" ====
" ==== fzf
" ====

" preview window on the right with 40% width, <C-p> will toggle preview window.
" see `--preview-window` section of `man fzf`
let g:fzf_preview_window = ['right:50%', 'ctrl-p']
" key bindings
nnoremap <A-b> :Buffers<CR>
nnoremap <A-f> :Files<CR>
nnoremap <A-h> :History<CR>
nnoremap <A-r> :Rg<SPACE>

" ====
" ==== vim-airline
" ====

" select colorscheme
silent! colorscheme onedark
" config doc: https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
" recommend MesloLGS Nerd Font Mono (https://github.com/ryanoasis/nerd-fonts)
let g:airline_theme = 'onedark'
let g:airline_powerline_fonts = 1
" enable the list of buffer
let g:airline#extensions#tabline#enabled = 1
" show buffer number
let g:airline#extensions#tabline#buffer_nr_show = 1
" show just the filename without path
let g:airline#extensions#tabline#fnamemod = ':t'
" truncate non-active buffer names to specified length
let g:airline#extensions#tabline#fnametruncate = 16
