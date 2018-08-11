" Configuration file for vim

" Portability
if has("win32")
    let $VIMFILES=expand("$VIM/vimfiles")
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
else " Assume Unix
    let $VIMFILES=expand("$HOME/.vim")
endif

" don't behave like vi
set nocompatible

syntax on

" Colors on HP and Sun!
"set t_Co=8
"set t_AB=[4%p1%dm
"set t_AF=[3%p1%dm

" various options
"set columns=150
set linespace=0
"set guifont=Lucida_Console:h8:cANSI
set bdir=~/.tmp,.
set dir=~/.tmp,.,/tmp
set history=50
set viminfo='20,\"50
set backspace=2
set whichwrap=<,>,[,],h,l
set fileformat=unix
set sessionoptions+=slash,unix
set shortmess+=I
set showcmd
set showmatch
set nostartofline
set wildmode=list:full
set autoindent
set cinoptions=(0
set hidden
set tags+=../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
"set mouse=a
set nobackup
set nowritebackup
set number
nmap ,m :call ToggleMouse()<CR>

" Commands
" toggle line numbers
command! Nl if (&nu) <Bar> set nonu <Bar> else <Bar> set nu <Bar> endif
" Convert to html with the colorscheme you are using
command! ToHtml runtime! syntax/2html.vim
" Convert a TTServer log file into a nice TTServer injector file
command! CleanTTLog call CleanTTLog()

""""""" Tests!!! """""""
" clean a file when a moron has used it before
" command! Clean call CleanCode()

" Colors
"noremap <F5> :call SetColorscheme("morning")<CR>:set bg=dark<CR>
"noremap <F6> :call SetColorscheme("murphy")<CR>
"noremap <F7> :call SetColorscheme("koehler")<CR>
"noremap <F8> :call SetColorscheme("evening")<CR>

" Tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set smarttab
set expandtab

" Show tabs and trailing spaces
set listchars=tab:>-,trail:-
set listchars+=extends:+,precedes:+
"set listchars+=eol:$
"set list
nmap ,l :set invlist<CR>

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch
nmap ,h :noh<CR>

" Folding
"EP Disable Folding
"EP set foldmethod=indent
"EP set foldlevel=12

" Scrolling
set scrolloff=3
noremap <C-J> 8<C-E>
inoremap <C-J> <C-O>8<C-E>
vnoremap <C-J> <C-C>8<C-E>
noremap <C-K> 8<C-Y>
inoremap <C-K> <C-O>8<C-Y>
vnoremap <C-K> <C-C>8<C-Y>
map <C-Down> <C-J>
map <C-Up> <C-K>

" Statusline
set ruler
set laststatus=2
set statusline=%2*[%02n]%*\ %f\ %3*%(%m%)%4*%(%r%)%*%=%b\ 0x%B\ \ <%l,%c%V>\ %P
function! UpdateStatusLine()
    hi User2 cterm=NONE ctermfg=yellow ctermbg=black guifg=yellow guibg=black
    hi User3 cterm=NONE ctermfg=black ctermbg=red guifg=black guibg=red
    hi User4 cterm=NONE ctermfg=green ctermbg=black guifg=green guibg=black
endfunction

" Formatting
set textwidth=0
"EP set formatoptions+=nl
" Format a paragraph (needs tw!=0)
"EP map & gqap
" Format using par
"EP map é {v}! par 72<CR>
" Format and right-justify
"EP map @ {v}! par 72j<CR>
" Rot13 transformation
"EP map # g?ap
"map # {v}! tr a-zA-Z n-za-mN-ZA-M<CR>

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files I am not likely to want to edit or read.
set suffixes=~,.aux,.bak,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.info,.inx,.log,.o,.obj,.out,.swp,.toc

" My favourite abbreviations
noreabbrev teh the
noreabbrev aps pas
iabbrev yalp abcdefghijklmnopqrstuvwxyz
iabbrev yALP ABCDEFGHIJKLMNOPQRSTUVWXYZ
iabbrev cad c'est-à-dire
iabbrev qqn quelqu'un
iabbrev /*t /*****************************************************************************
iabbrev /*b *****************************************************************************/

" Cscope stuff (very useful for developers!)
if has("cscope")
"    set csprg=cscope
    set cspc=3
    set csto=0
    set nocst " strange display sometimes
"     set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DIR != ""
        cs add $CSCOPE_DIR/cscope.out
        cd $CSCOPE_DIR
    endif
    set csverb

    " Useful mappings
    nmap ,cs :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap ,cg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap ,cd :cs find d <C-R>=expand("<cword>")<CR><CR>
    nmap ,cc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap ,ct :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap ,ce :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap ,cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap ,ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    " Special one, to find where the current file is #included
    nmap ,c% :cs find i <C-R>=expand("%:t")<CR><CR>

    " Abbreviation for commandline
    cab csf cs find
endif

" Expand #i to #include <.h> or #include ".h". The latter is chosen
" if the character typed after #i is a dquote
" If the character is > #include <> is inserted (standard C++ headers w/o .h)
iab #i <C-R>=SmartInclude()<CR>

" Switch between header and implementation files (using the 'a.vim' plugin)
nmap ,f :A<CR>

" update/reload .vimrc
nmap ,s :source $HOME/.vimrc<CR>
nmap ,v :sp $HOME/.vimrc<CR>

" set/unset paste mode
nmap ,p :set invpaste<CR>

" tags navigation (useful for a french keyboard...)
map <C-M> <C-]>

" Shortcuts for autocompletion
inoremap <C-L> <C-X><C-L>
inoremap <C-N> <C-X><C-N>
inoremap <C-P> <C-X><C-P>
inoremap <Tab> <C-R>=InsertTabWrapper("backward")<cr>
inoremap <S-Tab> <C-R>=InsertTabWrapper("forward")<cr>
set dictionary+=/usr/share/dict/french
set thesaurus+=/usr/dict/thesaurus

" Move as expected in visual mode
vnoremap <Left> h
vnoremap <Down> j
vnoremap <Up> k
vnoremap <Right> l
vnoremap <Home> ^
vnoremap <End> $
vnoremap <PageUp> 30k
vnoremap <PageDown> 30j

" In Visual mode, backspace deletes selection
vnoremap <BS> d

" Use CTRL-S for saving, also in Insert mode
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Use CTRL-K for code formatting
map <C-K> :pyf /usr/local/Cellar/clang-format/2018-01-11/share/clang/clang-format.py<CR>
imap <C-K> <C-O>:pyf /usr/local/Cellar/clang-format/2018-01-11/share/clang/clang-format.py<CR>

""""""""""""""
" autommands "
""""""""""""""

if has("autocmd")

augroup gzip
    " remove all gzip autocommands
    au!
augroup END

" we need tabs for a Makefile
autocmd BufEnter [mM]akefile* set noet

" I wonder why cindent isn't the default for c++ files...
autocmd BufEnter *.cpp,*.hpp,*.cc,*.hh,*.h set cindent
autocmd BufEnter *.java set cindent
autocmd BufEnter *.i setf cpp
autocmd Syntax cpp call EnhanceSyntax()

" automatic code formatting
autocmd BufWritePre *.hpp,*.h,*.cc,*.cpp call Formatonsave()

endif " has("autocmd")


"""""""""""""
" functions "
"""""""""""""

" Add highlighting for function definition in C++
function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
    hi def link cppFuncDef Special
endfunction

function! SetColorscheme(newColo)
    execute "colo " . a:newColo
    " Change the colors of the status bar
    call UpdateStatusLine()
endfunction

function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

function! CleanCode()
    " replace tabs with spaces
    %s/\t/    /g
    " add a space after commas, if necessary
"    %s/,\([^ ]\)/, \1/g
    " remove final ""
    %s/$//g
    " remove trailing spaces
    %s/ \+$//g
endfunction

function! ToggleMouse()
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
    echon "mouse=" &mouse
endfunction

function! SmartInclude()
    let next = nr2char( getchar( 0 ) )
    if next == '"'
        return "#include \".hpp\"\<Left>\<Left>\<Left>\<Left>\<Left>"
    endif
    if next == '>'
        return "#include <>\<Left>"
    endif
    return "#include <.h>\<Left>\<Left>\<Left>"
endfunction

function! CleanTTLog()
    g/^'[^']/d
    g/^UNB/d
    g/^UNZ/d
    g/^''UNB/d
    g/^''UNZ/d
    g/^$/d
    %s/^\(UNT.*'\)&/\1/
    %s/^\(''UNT.*'\)&/\1/
    %s/esponse\nUNH/esponse\r\r\rUNH/
endfunction

function! Formatonsave()
  let l:formatdiff = 1
  pyf /usr/local/Cellar/clang-format/2018-01-11/share/clang/clang-format.py
endfunction

"""""""""""
" Plugins "
"""""""""""

let g:mapleader = "`"

"" EnhancedCommentify
let g:EnhCommentifyPretty = "yes"
"let g:EnhCommentifyUseAltKeys = "yes"
let g:EnhCommentifyUseSyntax = "yes"
let g:EnhCommentifyTraditionalMode = "no"
let g:EnhCommentifyFirstLineMode = "yes"

"" MiniBufferExplorer
" We can't set a value <3, otherwise the 2html plugin doesn't work as expected
" (it Htmlizes the minibufferwindow!)
let g:miniBufExplorerMoreThanOne = 3

"" Taglist
let Tlist_Ctags_Cmd="ctags"

"" 2html
let html_use_css = 1

"" plugin package manager
execute pathogen#infect()

" runtime ftplugin/man.vim


"""""""""""""""""""
" Others commands "
"""""""""""""""""""

map! [1~ <Home>
map! [2~ <Insert>
map! [3~ <Del>
map! [4~ <End>
map! [5~ <PageUp>
map! [6~ <PageDown>
map [1~ <Home>
map [2~ <Insert>
map [3~ <Del>
map [4~ <End>
map [5~ <PageUp>
map [6~ <PageDown>
map [11~ <F1>
map [12~ <F2>
map [13~ <F3>
map [14~ <F4>
map [15~ <F5>
map [17~ <F6>
map [18~ <F7>
map [19~ <F8>
map [20~ <F9>
map [21~ <F10>
map [23~ <F11>
map [24~ <F12>

command! Edit execute "!cvs edit %:p"
"colo evening
"call UpdateStatusLine()
