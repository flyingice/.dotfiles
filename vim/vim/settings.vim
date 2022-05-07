"  ____       _   _   _
" / ___|  ___| |_| |_(_)_ __   __ _ ___
" \___ \ / _ \ __| __| | '_ \ / _` / __|
"  ___) |  __/ |_| |_| | | | | (_| \__ \
" |____/ \___|\__|\__|_|_| |_|\__, |___/
"                             |___/
"
" Author: @flyingice

" vim is based on vi.
" Setting `nocompatible` switches from the default vi-compatibility mode
" and enables useful vim functionality. This configuration option turns out
" not to be necessary for the file named '~/.vimrc', because vim automatically
" enters nocompatible mode if that file is present. But we're including it here
" just in case this config file is loaded some other way
" (e.g. saved as `foo`, and then vim started with " `vim -u foo`).
set nocompatible

" change default viminfo location
" Neovim uses Shada files instead of viminfo format
if !has('nvim')
    set viminfo+=n~/.config/vim/viminfo
endif

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
" ttymouse option was removed from Neovim as mouse support should work without it.
if !has('nvim')
    set ttymouse=sgr
endif

" set default code folding method
set foldmethod=indent

" avoid delay when pressing <ESC>
" set mapping delay
set timeoutlen=1000
" set keycode delay
set ttimeoutlen=0

" restore cursor position at next file reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
