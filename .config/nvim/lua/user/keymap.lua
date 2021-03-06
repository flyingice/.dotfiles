--[[
 _  __
| |/ /___ _   _ _ __ ___   __ _ _ __
| ' // _ \ | | | '_ ` _ \ / _` | '_ \
| . \  __/ |_| | | | | | | (_| | |_) |
|_|\_\___|\__, |_| |_| |_|\__,_| .__/
          |___/                |_|

Author: @flyingice

:help key-notation
https://neovim.io/news/2022/04
vim.keymap.set sets noremap by default

--]]

local set = vim.keymap.set

-- set leader key
set('', '<Space>', '<NOP>', {
  desc = 'use space as leader key instead of default backslash'
})
vim.g.mapleader = ' '

-- disable some keys
set('', 's', '<NOP>', {
  desc = 'disable delete chracter'
})

set('', 'gt', '<NOP>', {
  desc = 'disable go to next tab'
})

set('', 'gT', '<NOP>', {
  desc = 'disable go to previous tab'
})

-- ==================== normal mode ====================

-- <C-a> is already taken as tmux prefix key
set('n', '<C-q>', '<C-a>', {
  desc = 'add'
})

-- common operations
set('n', 'S', ':w<CR>', {
  desc = 'write to file'
})
set('n', 'Q', ':q<CR>', {
  desc = 'quit'
})
set('n', 'oo', 'o<Esc>k', {
  desc = 'insert a new line below'
})
set('n', 'OO', 'O<Esc>j', {
  desc = 'insert a new line above'
})

-- window split
set('n', 'sh', ':set nosplitright<CR>:vsplit<CR>', {
  desc = 'split a new window vertically with cursor focus on the left'
})
set('n', 'sl', ':set splitright<CR>:vsplit<CR>', {
  desc = 'split a new window vertically with cursor focus on the right'
})
set('n', 'sk', ':set nosplitbelow<CR>:split<CR>', {
  desc = 'split a new window horizontally with cursor focus at the bottom'
})
set('n', 'sj', ':set splitbelow<CR>:split<CR>', {
  desc = 'split a new window horizontally with cursor focus on the top'
})

-- buffer traversal
set('n', '[b', ':bprevious<CR>', {
  desc = 'go to the previous buffer'
})
set('n', ']b', ':bnext<CR>', {
  desc = 'go to the next buffer'
})
set('n', '[B', ':bfirst<CR>', {
  desc = 'go to the first buffer'
})
set('n', ']B', ':blast<CR>', {
  desc = 'go to the last buffer'
})

-- quickfix list traversal
set('n', '[q', ':cprevious<CR>', {
  desc = 'go to the previous position in the quickfix list'
})
set('n', ']q', ':cnext<CR>', {
  desc = 'go to the next position in the quickfix list'
})
set('n', '[Q', ':cfirst<CR>', {
  desc = 'go to the first position in the quickfix list'
})
set('n', ']Q', ':clast<CR>', {
  desc = 'go to the next position in the quickfix list'
})

-- jumplist traversal
set('n', '[l', ':lprevious<CR>', {
  desc = 'go to the previous position in the jumplist'
})
set('n', ']l', ':lnext<CR>', {
  desc = 'go to the next position in the jumplist'
})
set('n', '[L', ':lfirst<CR>', {
  desc = 'go to the first position in the jumplist'
})
set('n', ']L', ':llast<CR>', {
  desc = 'go to the last position in the jumplist'
})

-- jump to placeholder <++>
set('n', '<Leader><Leader>', '<Esc>/<++><CR>:nohlsearch<CR>c4l', {
  desc = 'jump to the next placeholder and edit'
})

-- ==================== insert mode ====================

set('i', '<S-Tab>', '<C-d>', {
  desc = 'back up one tab stop'
})

-- ==================== visual mode ====================

set('v', '.', ':normal! .<CR>', {
  desc = 'repeat dot action'
})

-- ==================== terminal mode ====================

-- press <C-\><C-n> to switch to terminal normal mode

--[[
facilitate going back to original window
<C-w> is chosen here to be consistent with default window rotation mapping
in normal mode. The downside is that we can't use <C-w> to delete a word
anymore in terminal insert mode.
--]]
set('t', '<C-w>', [[<C-\><C-n><C-w>]], {
  desc = 'window rotation'
})

-- ==================== misc ====================

--[[
avoid strange indentation when using system paste command, in particular
when the 'autoindent' option is enabled. Alternatively, you can run the
ex command :set paste before pasting from the system clipboard and then
run :set paste! to turn the option off. A more elegant solution would be
the normal mode command "+p that preserves the indentation of the text
without any surprises.
--]]
vim.cmd [[ set pastetoggle=<F12> ]]

-- type %% in Ex mode to expand directory of the active buffer (equivalent to %:h)
vim.cmd [[ cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%' ]]
