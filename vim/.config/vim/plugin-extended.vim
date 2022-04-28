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

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'joshdick/onedark.vim'
Plug 'arzg/vim-colors-xcode'

" Initialize plugin system
call plug#end()

" ====
" ==== lazygit
" ====

" key bindings
nnoremap <A-g> :term lazygit<CR><C-w>_

" ====
" ==== NERDTree
" ====

" key bindings
nnoremap <A-t> :NERDTreeToggle<CR>

" ====
" ==== fzf
" ====
"
" preview window on the right with 40% width, CTRL-/ will toggle preview window.
" see `--preview-window` section of `man fzf`
let g:fzf_preview_window = ['right:40%', 'ctrl-/']
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
