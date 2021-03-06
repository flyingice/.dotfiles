--[[
  ___        _   _
 / _ \ _ __ | |_(_) ___  _ __
| | | | '_ \| __| |/ _ \| '_ \
| |_| | |_) | |_| | (_) | | | |
 \___/| .__/ \__|_|\___/|_| |_|
      |_|

Author: @flyingice

https://neovim.io/doc/user/vim_diff.html#nvim-defaults

--]]

local options = {
  -- show line numbers
  number = true,
  --[[
  enable relative line numbering
  With both number and relative number enabled, the current line shows the true
  line number, while all other lines are numbered relative to the current line.
  --]]
  relativenumber = true,
  -- highlight current line
  cursorline = true,
  -- don't show tabline as I never use :tabnew
  showtabline = 0,
  -- show current mode on the statusline
  showmode = true,
  -- enable global statusline (neovim 0.7 new feature)
  laststatus = 3,
  -- expand tab to spaces, :retab to replace existing tabs
  expandtab = true,
  -- customize width of tab and autoindent
  tabstop = 2,
  shiftwidth = 2,
  -- reacts to the syntax/style of the code you are editing
  smartindent = true,
  -- set default code folding method (maybe overwritten by treesitter setttings)
  foldmethod = 'indent',
  --[[
  make search case-insensitive when all the characters in the string are lowercase,
  but become case-sensitive with any capital letters in the string being searched
  --]]
  ignorecase = true,
  smartcase = true,
  -- fix the side effect of 'ignorecase' for autocompletion
  infercase = true,
  -- make at least 5 lines visible above and below the cursor
  scrolloff = 5,
  -- vim doesn't allow to hide a buffer with unsaved changes by default
  hidden = true,
  -- hide concealed text (e.g. hyperlink in markdown file)
  conceallevel = 2,
  -- enable mouse support
  mouse = 'a',
  -- enable true color support
  termguicolors = true,
  -- don't redraw screen while executing macros, registers
  lazyredraw = true,
}

-- disable the default vim startup message
vim.opt.shortmess:append 'I'

for key, value in pairs(options) do
  vim.opt[key] = value
end
