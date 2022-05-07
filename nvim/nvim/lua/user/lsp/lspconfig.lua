-- Author: @flyingice

local status, lspconfig = pcall(require, 'lspconfig')
if not status then
  vim.notify('fail to load lspconfig')
  return
end

local set = vim.api.nvim_set_keymap
local buf_set = vim.api.nvim_buf_set_keymap
local opts = { noremap = true, silent = true }

-- `:help vim.diagnostic.*` for documentation on any of the below functions
set('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
set('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- use on_attach function to only map keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- `:help vim.lsp.*` for documentation on any of the below functions
  buf_set(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set(bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set(bufnr, 'n', '<Leader>c', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set(bufnr, 'n', '<Leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set(bufnr, 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  buf_set(bufnr, 'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set(bufnr, 'n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set(bufnr, 'n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- TODO: scan subdir to hava the servers instead of hard coding a list
local servers = { 'sumneko_lua' }
for _, server in pairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    -- capabilities = capabilities,
    flags = {
      -- default in neovim 0.7+
      debounce_text_changes = 150,
    },
    settings = require('user.lsp.' .. server)
  }
end
