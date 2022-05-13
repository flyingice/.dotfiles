-- Author: @flyingice

-- https://github.com/neovim/nvim-lspconfig
local status, lspconfig = pcall(require, 'lspconfig')
if not status then
  vim.notify('fail to load lspconfig')
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local utils = require('user.lsp.utils')
-- keybindings for LSP diagnostics
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
