-- Author: @flyingice

-- https://github.com/nvim-treesitter/nvim-treesitter
require 'nvim-treesitter.configs'.setup {
  -- a list of parser names, or 'all'
  ensure_installed = { 'lua' },
  -- install parsers synchronously
  sync_install = false,

  --[[
  https://github.com/nvim-treesitter/nvim-treesitter#Modules
  https://github.com/nvim-treesitter/nvim-treesitter/wiki/Extra-modules-and-plugins
  --]]

  -- syntax highlighting
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- disable highlighting for the following list of lauguage parsers
    disable = {},
    -- disable vim syntax highlighting
    additional_vim_regex_highlighting = false,
  },

  --[[
  syntax aware text-objects support
  https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  --]]
  textobjects = {
    select = {
      enable = true,
      -- automatically jump forward, similar to wellle/targets.vim
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },

    swap = {
      enable = false,
    },

    move = {
      enable = true,
      -- whether to set jumps in the jumplist
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
    },

    --[[
    show textobject surrounding definition as determined using
    Neovim's built-in LSP in a floating window
    --]]
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>d"] = "@function.outer",
        ["<leader>D"] = "@class.outer",
      },
    },
  },
}

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
