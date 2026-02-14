-- Author: @flyingice

--[[
https://github.com/lukas-reineke/indent-blankline.nvim
--]]
local status, indentline = pcall(require, 'ibl')
if not status then
  vim.notify('fail to load indent-blankline.nvim')
  return
end

-- settings
indentline.setup({
  indent = {
    char = '¦',
  },

  scope = {
    -- use treesitter to determine the current context, show in different highlight
    enabled = true,
    -- highlight the first line of the current context
    show_start = false,
    char = '¦',
  },
})

-- keybindings
vim.keymap.set('n', '<Leader>gl', ':IndentBlanklineToggle!<CR>', {
  desc = 'toggle indent lines'
})
