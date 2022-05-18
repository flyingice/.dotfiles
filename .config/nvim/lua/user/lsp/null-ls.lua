-- Author: @flyingice

--[[
https://github.com/jose-elias-alvarez/null-ls.nvim
--]]
local status, null_ls = pcall(require, 'null-ls')
if not status then
  vim.notify('fail to load null-ls.nvim')
  return
end

null_ls.setup({
  --[[
  https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  --]]
  sources = {
    -- bash formatter
    null_ls.builtins.formatting.shfmt.with({
      -- indent with two spaces
      extra_args = { '-i', '2' },
    }),
    -- python formatter
    null_ls.builtins.formatting.black,
  }
})
