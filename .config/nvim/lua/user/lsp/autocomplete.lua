-- Author: @flyingice

--[[
https://github.com/hrsh7th/nvim-cmp
--]]
local status_cmp, cmp = pcall(require, 'cmp')
if not status_cmp then
  vim.notify('fail to load nvim-cmp')
  return
end

--[[
https://github.com/hrsh7th/cmp-nvim-lsp
--]]
local status_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_cmp_lsp then
  vim.notify('fail to load cmp-nvim-lsp')
  return
end

--[[
https://github.com/L3MON4D3/LuaSnip
--]]
local status_luasnip, luasnip = pcall(require, 'luasnip')
if not status_luasnip then
  vim.notify('fail to load LuaSnip')
  return
end

-- nvim-cmp setup
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
  },
}

-- cmp-nvim-lsp setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_lsp.default_capabilities(capabilities)

-- LuaSnip will load the existing vscode-style snippets on startup
require("luasnip.loaders.from_vscode").lazy_load()
