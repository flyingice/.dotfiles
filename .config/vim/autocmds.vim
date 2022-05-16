"     _         _                           _
"    / \  _   _| |_ ___   ___ _ __ ___   __| |
"   / _ \| | | | __/ _ \ / __| '_ ` _ \ / _` |
"  / ___ \ |_| | || (_) | (__| | | | | | (_| |
" /_/   \_\__,_|\__\___/ \___|_| |_| |_|\__,_|
"
" Author: @flyingice

" restore cursor position at next file reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
