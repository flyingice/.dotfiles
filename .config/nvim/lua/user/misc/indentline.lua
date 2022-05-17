-- Author: @flyingice

--[[
https://github.com/lukas-reineke/indent-blankline.nvim
--]]
local status, indentline = pcall(require, 'indent_blankline')
if not status then
  vim.notify('fail to load indent-blankline.nvim')
  return
end

-- settings
indentline.setup({
  char = '¦',
  context_char = '¦',
  -- use treesitter to determine the current context, show in different highlight
  show_current_context = true,
  -- highlight the first line of the current context
  show_current_context_start = false,
})

-- keybindings
vim.keymap.set('n', '<Leader>gl', ':IndentBlanklineToggle!<CR>', {
  desc = 'toggle indent lines'
})
