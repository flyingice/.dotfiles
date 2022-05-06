-- Author: @flyingice

-- settings
-- preview window on the right with 50% width, <C-/> will toggle preview window
-- see `--preview-window` section of `man fzf`
vim.g.fzf_preview_window = {
  'right:50%',
  'ctrl-/'
}

-- keybindings
vim.keymap.set('n', '<A-b>', ':Buffers<CR>', {
  desc = '(fzf) list opened buffers'
})
vim.keymap.set('n', '<A-f>', ':Files<CR>', {
  desc = '(fzf) list files under the current working directory'
})
vim.keymap.set('n', '<A-h>', ':History<CR>', {
  desc = '(fzf) list historically opened files'
})
vim.keymap.set('n', '<A-r>', ':Rg<CR>', {
  desc = '(fzf) search keyword globally'
})
