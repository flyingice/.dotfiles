-- Author: @flyingice

--[[
https://github.com/junegunn/fzf.vim
--]]

-- preview window on the right with 50% width, <C-/> will toggle preview window
-- see `--preview-window` section of `man fzf`
vim.g.fzf_preview_window = {
  'right:50%',
  'ctrl-/'
}

-- keybindings
vim.keymap.set('n', '<A-b>', ':Buffers<CR>', {
  desc = 'list opened buffers'
})
vim.keymap.set('n', '<A-f>', ':Files<CR>', {
  desc = 'list files under the current working directory'
})
vim.keymap.set('n', '<A-h>', ':History<CR>', {
  desc = 'list historically opened files'
})
vim.keymap.set('n', '<A-r>', ':Rg<CR>', {
  desc = 'search keyword globally'
})
