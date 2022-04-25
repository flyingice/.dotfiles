" set leader key to space instead of default backslash
nnoremap <SPACE> <Nop>
let mapleader=" "

" unbind some useless/annoying default keys
map s <Nop>

" back up one tab stop
" <TAB> already has the same effect as <C-T>
inoremap <S-TAB> <C-d>

" <C-a> is taken as tmux prefix key
nnoremap <C-q> <C-a>

" common file operations
nmap S :w<CR>
nmap Q :q<CR>

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

" expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 'selection for find' feature
" The key mappings apply to visual mode only.
" credit to https://github.com/nelstrom/vim-visual-star-search
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
