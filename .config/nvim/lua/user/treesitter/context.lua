-- Author: @flyingice

--[[
https://github.com/nvim-treesitter/nvim-treesitter-context
--]]

local status, context = pcall(require, 'treesitter-context')
if not status then
  vim.notify('fail to load nvim-treesitter-context')
  return
end

context.setup({
  enable = true,
  -- number of lines the window should span, no limit with value <= 0
  max_lines = 0,
})
