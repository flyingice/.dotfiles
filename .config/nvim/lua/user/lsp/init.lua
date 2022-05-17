-- Author: @flyingice

--[[
https://github.com/neovim/nvim-lspconfig
--]]
local status, lspconfig = pcall(require, 'lspconfig')
if not status then
  vim.notify('fail to load nvim-lspconfig')
  return
end

-- keybindings for LSP diagnostics
local utils = require('user.lsp.utils')
utils.set_keymap()

local servers = utils.get_servers()
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = utils.on_attach,
    -- capabilities = capabilities,
    flags = {
      -- default in neovim 0.7+
      debounce_text_changes = 150,
    },
    settings = require('user.lsp.servers.' .. server)
  }
end
