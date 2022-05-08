-- Author: @flyingice

local status, luasnip = pcall(require, 'luasnip')
if not status then
  vim.notify('fail to load luasnip')
  return
end

--[[
https://github.com/L3MON4D3/LuaSnip
LuaSnip will load the existing vscode-style snippets on startup
--]]
require("luasnip.loaders.from_vscode").lazy_load()

return luasnip
