" ====
" ==== settings for IntelliJ IDEA IdeaVim plugin
" ====

" list of supported set commands: https://github.com/JetBrains/ideavim/wiki/%22set%22-commands
" enable smart join operation: https://github.com/JetBrains/ideavim/wiki/%22ideajoin%22-examples
set ideajoin

" ====
" ==== key bindings
" ====

" toggle maximize current editor/normalize split
nmap <C-w>= :action MaximizeEditorInSplit<CR>

" workaround as ctrl+t doesn't always respect default vim behavior
nmap <C-t> :action Back<CR>

" find all usages
nmap <Leader>g :action FindUsages<CR>

" reformat
nmap <Leader>f :action ReformatCode<CR><ESC>

" rename
nmap <Leader>r :action RenameElement<CR>

" ====
" ==== plugin emulation
" ====

" https://tpope.io/vim/commentary.git
set commentary

" https://github.com/chrisbra/matchit
set matchit

" https://github.com/preservim/nerdtree
set NERDTree

nmap <Leader><C-n> :NERDTreeToggle<CR>

" https://github.com/tpope/vim-surround
set surround
