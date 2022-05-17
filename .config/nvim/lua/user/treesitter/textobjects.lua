-- Author: @flyingice

--[[
https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--]]
return {
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
    -- press the shortcut twice to enter the floating window
    peek_definition_code = {
      ["<Leader>d"] = "@function.outer",
      ["<Leader>D"] = "@class.outer",
    },
  },
}
