" enable file-type plugin
filetype plugin on

" vim is based on vi.
" Setting `nocompatible` switches from the default vi-compatibility mode
" and enables useful vim functionality. This configuration option turns out
" not to be necessary for the file named '~/.vimrc', because vim automatically
" enters nocompatible mode if that file is present. But we're including it here
" just in case this config file is loaded some other way
" (e.g. saved as `foo`, and then vim started with " `vim -u foo`).
set nocompatible

" turn on syntax highlighting
syntax on

" disable the default vim startup message
set shortmess+=I

" show line numbers.
set number

" enables relative line numbering mode
" With both number and relativenumber enabled, the current line shows the true
" line number, while all other lines (above and below) are numbered relative to
" the current line. This is useful because you can tell, at a glance, what count
" is needed to jump up or down to a particular line, by {count}k to go up or
" {count}j to go down.
set relativenumber

" highlight current line
set cursorline

" always show the status line at the bottom, even if you only have one window open
set laststatus=2

" status line to show current mode
set showmode

" always show the command entered
set showcmd

" enable command auto-completion with enhanced mode
set wildmenu

" customize width of tab and auto-indent
set tabstop=4
set shiftwidth=4
" expand tab to spaces, :retab to replace existing tabs
set expandtab

" apply the indentation of the current line to the next
set autoindent
" reacts to the syntax/style of the code you are editing
set smartindent

" The backspace key has slightly unintuitive behavior by default.
" For example, by default, you can't backspace before the insertion point set with
" 'i'. This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
" Unfortunately, it has a side effect that the autocompletion also becomes
" case insensitive.
set ignorecase
set smartcase

" fix the side effect of 'ignorecase' for autocompletion
set infercase

" enable searching as you type, rather than waiting till you press enter
set incsearch

" enable search highlighting, use <C-l> to mute it temporarily
set hlsearch

" make at least 5 lines visible above and below the cursor
set scrolloff=5

" disable audible bell because it's annoying
set noerrorbells visualbell t_vb=

" enable mouse support
" You should avoid relying on this too much, but it can sometimes be convenient.
set mouse+=a
" enable window resizing with mouse dragging (default on xterm)
set ttymouse=sgr

" Avoid strange indentation when using system paste command, in particular
" when the 'autoindent' option is enabled. Alternatively, you can run the
" ex command :set paste before pasting from the system clipboard and then
" run :set paste! to turn the option off. A more elegant solution would be
" the normal mode command "+p that preserves the indentation of the text
" without any surprises.
set pastetoggle=<F5>

" set default code folding method
set foldmethod=indent

" avoid delay when pressing <ESC>
" set mapping delay
set timeoutlen=1000
" set keycode delay
set ttimeoutlen=0

"****************************************
" key bindings
"****************************************

" set leader key to space instead of default backslash
nnoremap <SPACE> <Nop>
let mapleader=" "

" unbind some useless/annoying default keys
map s <Nop>

" common file operations
nmap S :w<CR>
nmap Q :q<CR>

" back up one tab stop
" <TAB> already has the same effect as <C-T>
inoremap <S-TAB> <C-d>

" insert a newline
nnoremap oo o<ESC>k
nnoremap OO O<ESC>j

" window splitting
nnoremap sh :set nosplitright<CR>:vsplit<CR>
nnoremap sl :set splitright<CR>:vsplit<CR>
nnoremap sk :set nosplitbelow<CR>:split<CR>
nnoremap sj :set splitbelow<CR>:split<CR>

" buffer list traversal
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" quickfix list traversal
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

" location list traversal
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>

" mute search highlighting
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" 'selection for find' feature
" The key mappings apply to visual mode only.
" credit to https://github.com/nelstrom/vim-visual-star-search
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" import plugin settings
source ~/.vimrc.ext
