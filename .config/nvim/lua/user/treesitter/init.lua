-- Author: @flyingice

--[[
https://github.com/nvim-treesitter/nvim-treesitter (main branch — Neovim 0.12+)

The main branch is a rewrite: there is no `require('nvim-treesitter.configs').setup{}`,
no `ensure_installed` option, and no built-in modules. Highlight/indent are enabled via
autocmd, parsers are installed via the `install()` API, and textobjects/context are
configured in their own files.
--]]

-- Parsers to keep installed.
-- NOTE: Neovim 0.12 ships these out of the box and they should NOT be listed here
local ensure_installed = {
  'cpp', 'java', 'python', 'yaml',
}

local ok, ts_config = pcall(require, 'nvim-treesitter.config')
if not ok then
  vim.notify('fail to load nvim-treesitter')
  return
end

local installed = ts_config.get_installed() or {}
local to_install = vim.iter(ensure_installed)
  :filter(function(p) return not vim.tbl_contains(installed, p) end)
  :totable()
if #to_install > 0 then
  require('nvim-treesitter').install(to_install)
end

-- Enable highlight + treesitter-based indent on every buffer that has a parser.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require('user.treesitter.textobjects')
require('user.treesitter.folding')
