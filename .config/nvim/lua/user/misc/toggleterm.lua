-- Author: @flyingice

--[[
https://github.com/akinsho/toggleterm.nvim
--]]
local status, toggleterm = pcall(require, 'toggleterm')
if not status then
  vim.notify('fail to load toggleterm.nvim')
end

-- general settings
toggleterm.setup({
  -- insert mode when opening a terminal
  start_int_insert = true,
  -- close the terminal window when the process exits
  close_on_exit = true,
  -- vertical | horizontal | tab | float
  direction = 'horizontal',
})

-- lazygit quick launch
local lazygit = require('toggleterm.terminal').Terminal:new({
  cmd = 'lazygit',
  direction = 'float',
  float_opts = {
    border = 'double',
  },
})

function _lazygit_toggle()
  lazygit:toggle()
end

-- keybindings
local set = vim.keymap.set

set('n', '<A-s>', ':ToggleTerm<CR>', {
  desc = 'toggle integrated terminal'
})

set('n', '<A-g>', ':lua _lazygit_toggle()<CR>', {
  desc = 'launch lazygit'
})
