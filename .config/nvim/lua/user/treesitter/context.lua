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
  -- enable the plugin
  enable = true,
  -- number of lines the window should span, no limit with value <= 0
  max_lines = 0,
  -- match patterns for TS nodes. These get wrapped to match at word boundaries.
  patterns = {
    --[[
    control which nodes to show in the context window for all filetypes
    setting an entry here replaces all other patterns for this entry
    --]]
    default = {
      'class',
      'function',
      'method',
      -- 'for',
      -- 'while',
      -- 'if',
      -- 'switch',
      -- 'case',
    },
    --[[
    example for a specific filetype
    --]]
    -- rust = {
    --   'impl_item',
    -- },
  },
  exact_patterns = {
    --[[
    example for a specific filetype with Lua patterns
    treat patterns.rust as a Lua pattern, e.g.,
    '^impl_item$' will exactly match 'impl_item' only
    --]]
    -- rust = true,
  },
})
