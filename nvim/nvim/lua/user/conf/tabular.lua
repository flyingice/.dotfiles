-- https://raw.githubusercontent.com/godlygeek/tabular/master/doc/Tabular.txt

-- keybindings
vim.keymap.set('n', '<Leader>ga', ':Tabularize /=<CR>', {
  desc = 'align text with = as delimiter'
})
vim.keymap.set('v', '<Leader>ga', ':Tabularize /=<CR>', {
  desc = 'align text with = as delimiter'
})
