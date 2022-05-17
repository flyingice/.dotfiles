-- Author: @flyingice

--[[
https://github.com/nvim-treesitter/nvim-treesitter
--]]
local status, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status then
  vim.notify('fail to load nvim-treesitter-textobjects')
  return
end

treesitter.setup {
  -- a list of parser names, or 'all'
  ensure_installed = { 'lua' },
  -- install parsers synchronously
  sync_install = false,

  --[[
  https://github.com/nvim-treesitter/nvim-treesitter#Modules
  https://github.com/nvim-treesitter/nvim-treesitter/wiki/Extra-modules-and-plugins
  --]]
  highlight = require('user.treesitter.highlight'),

  textobjects = require('user.treesitter.textobjects'),
}

require('user.treesitter.folding')
