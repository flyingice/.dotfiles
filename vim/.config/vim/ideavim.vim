"  ___    _          __     ___
" |_ _|__| | ___  __ \ \   / (_)_ __ ___
"  | |/ _` |/ _ \/ _` \ \ / /| | '_ ` _ \
"  | | (_| |  __/ (_| |\ V / | | | | | | |
" |___\__,_|\___|\__,_| \_/  |_|_| |_| |_|


" ====
" ==== basic settings
" ====
"
" full list of supported set commands:
" https://github.com/JetBrains/ideavim/wiki/%22set%22-commands
"
" enable smart join operation:
" https://github.com/JetBrains/ideavim/wiki/%22ideajoin%22-examples
set ideajoin

" ====
" ==== key bindings
" ====

" toggle maximize current editor/normalize split
nmap <C-w>= :action MaximizeEditorInSplit<CR>

" workaround as ctrl+t doesn't always respect default vim behavior
nmap <C-t> :action Back<CR>

" find all usages
nmap <A-r> :action FindUsages<CR>

" reformat
nmap <A-=> :action ReformatCode<CR><ESC>

" rename
nmap <A-c> :action RenameElement<CR>

" ====
" ==== plugin emulation
" ====

" https://tpope.io/vim/commentary.git
set commentary

" https://github.com/chrisbra/matchit
set matchit

" https://github.com/preservim/nerdtree
set NERDTree

nmap <A-t> :NERDTreeToggle<CR>

" https://github.com/tpope/vim-surround
set surround
