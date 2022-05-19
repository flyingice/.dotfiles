"     _         _                           _
"    / \  _   _| |_ ___   ___ _ __ ___   __| |___
"   / _ \| | | | __/ _ \ / __| '_ ` _ \ / _` / __|
"  / ___ \ |_| | || (_) | (__| | | | | | (_| \__ \
" /_/   \_\__,_|\__\___/ \___|_| |_| |_|\__,_|___/
"
" Author: @flyingice

" restore cursor position at next file reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
