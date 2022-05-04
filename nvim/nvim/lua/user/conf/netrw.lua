-- settings
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- keybindings
vim.keymap.set('n', '<A-t>', ':Vexplore<CR>', {
  desc = '(netrw) open explorer'
})
