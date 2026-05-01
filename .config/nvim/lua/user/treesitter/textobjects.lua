-- Author: @flyingice

--[[
https://github.com/nvim-treesitter/nvim-treesitter-textobjects (main branch)

The main branch replaces the old `keymaps` table with a function-based API:
`select_textobject` for selection, `goto_*` for movement. Map them yourself
with vim.keymap.set.
--]]

local ok, tobj = pcall(require, 'nvim-treesitter-textobjects')
if not ok then
  vim.notify('fail to load nvim-treesitter-textobjects')
  return
end

tobj.setup({
  select = {
    -- automatically jump forward, similar to wellle/targets.vim
    lookahead = true,
  },
  move = {
    -- whether to set jumps in the jumplist
    set_jumps = true,
  },
})

local select = require('nvim-treesitter-textobjects.select').select_textobject
local move   = require('nvim-treesitter-textobjects.move')

-- selection
local select_maps = {
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
}
for lhs, capture in pairs(select_maps) do
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    select(capture, 'textobjects')
  end)
end

-- movement
local move_maps = {
  [']f'] = { fn = move.goto_next_start,     capture = '@function.outer' },
  [']c'] = { fn = move.goto_next_start,     capture = '@class.outer' },
  [']F'] = { fn = move.goto_next_end,       capture = '@function.outer' },
  [']C'] = { fn = move.goto_next_end,       capture = '@class.outer' },
  ['[f'] = { fn = move.goto_previous_start, capture = '@function.outer' },
  ['[c'] = { fn = move.goto_previous_start, capture = '@class.outer' },
  ['[F'] = { fn = move.goto_previous_end,   capture = '@function.outer' },
  ['[C'] = { fn = move.goto_previous_end,   capture = '@class.outer' },
}
for lhs, m in pairs(move_maps) do
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    m.fn(m.capture, 'textobjects')
  end)
end

-- NOTE: lsp_interop / peek_definition_code (gk, gK) was removed in the main-branch
-- rewrite. Use vim.lsp.buf.hover() or a dedicated peek plugin if you want it back.
