-- Author: @flyingice

-- https://github.com/Yggdroot/indentLine
-- settings
-- disable by default
vim.g.indentLine_enabled = 0

-- keybindings
vim.keymap.set('n', '<Leader>gi', ':IndentLinesToggle<CR>', {
  desc = 'toggle indent lines'
})
