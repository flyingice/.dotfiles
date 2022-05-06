return {
  Lua = {
    diagnostics = {
      -- suppress warning: Undefined global 'vim'
      globals = { 'vim' },
    },
  },
}
