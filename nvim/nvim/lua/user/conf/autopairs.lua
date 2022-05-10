-- Author: @flyingice

-- https://github.com/windwp/nvim-autopairs
local status, autopairs = pcall(require, 'nvim-autopairs')
if not status then
  vim.notify('fail to load autopairs')
  return
end

autopairs.setup({
  disable_filetype = { 'vim' },
  -- disable when recording or executing a macro
  disable_in_macro = false,
  -- <A-e>: (|foo -> (|foo), (|)(foo) -> (|(foo))
  fast_wrap = {},
})
