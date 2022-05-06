-- Author: @flyingice

-- https://github.com/nvim-treesitter/nvim-treesitter#Modules
require 'nvim-treesitter.configs'.setup {
  -- a list of parser names, or 'all'
  ensure_installed = { 'cpp', 'lua', 'java', 'python' },
  -- install parsers synchronously
  sync_install = false,

  -- syntax highlighting
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- disable highlighting for the following list of lauguage parsers
    disable = {},
    -- disable vim syntax highlighting
    additional_vim_regex_highlighting = false,
  },
}

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
