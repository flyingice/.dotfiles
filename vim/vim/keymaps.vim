"  _  __
" | |/ /___ _   _ _ __ ___   __ _ _ __
" | ' // _ \ | | | '_ ` _ \ / _` | '_ \
" | . \  __/ |_| | | | | | | (_| | |_) |
" |_|\_\___|\__, |_| |_| |_|\__,_| .__/
"           |___/                |_|
"
" Author: @flyingice

" :help key-notation

" set leader key to space instead of default backslash
nnoremap <Space> <Nop>
let mapleader=" "

" unbind some useless/annoying default keys
map s <Nop>

" back up one tab stop
" <Tab> already has the same effect as <C-t>
inoremap <S-Tab> <C-d>

" <C-a> is taken as tmux prefix key
nnoremap <C-q> <C-a>

" common file operations
nmap S :w<CR>
nmap Q :q<CR>

" insert a newline
nnoremap oo o<Esc>k
nnoremap OO O<Esc>j

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

" expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 'selection for find' feature
" The key mappings apply to visual mode only.
" credit to https://github.com/nelstrom/vim-visual-star-search
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-r>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-r>=@/<CR><CR>

" Avoid strange indentation when using system paste command, in particular
" when the 'autoindent' option is enabled. Alternatively, you can run the
" ex command :set paste before pasting from the system clipboard and then
" run :set paste! to turn the option off. A more elegant solution would be
" the normal mode command "+p that preserves the indentation of the text
" without any surprises.
set pastetoggle=<F5>
