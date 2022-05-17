-- Author: @flyingice

--[[
==================== vim-instant-markdown ====================
https://github.com/instant-markdown/vim-instant-markdown/blob/master/doc/vim-instant-markdown.txt
--]]

--[[
only refresh on the following events:
* no keys have been pressed for a while
* leave insert mode for a while
* save the file being edited
vim-instant-markdown will update the display in realtime with instant_markdown_slow set to 0
--]]
vim.g.instant_markdown_slow = 1
-- don't automatically launch the preview window when a markdown file is opened
vim.g.instant_markdown_autostart = 0
-- live preview auto-scrolls to where your cursor is positioned
vim.g.instant_markdown_autoscroll = 1
-- choose a custom port instead of the default 8090
vim.g.instant_markdown_port = 8000

-- keybindings
vim.keymap.set('n', '<Leader>mp', ':InstantMarkdownPreview<CR>', {
  desc = 'preview markdown file in default browser'
})

--[[
==================== vim-table-mode ====================
https://github.com/dhruvasagar/vim-table-mode/blob/master/README.md
--]]

--[[
default key mappings:
:TableModeToggle <Leader>tm
:TableModeRealign <Leader>tr
:Tableize <Leader>tt

moving around:
left cell [|
right cell ]|
up cell {|
down cell }|

manipulating table:
cell text object i| & a|
delete row <Leader>tdd
delete column <Leader>tdc
insert column <Leader>tic / <Leader>tiC
--]]

--[[
==================== vim-markdown-toc ====================
https://github.com/mzlogin/vim-markdown-toc/blob/master/README.md#usage
--]]

-- change inner text of the fence marker
vim.g.vmt_fence_text = 'TOC'
vim.g.vim_fence_closing_text = '/TOC'
-- every level will cycle between the valid list item markers *, - and +
vim.g.vmt_cycle_list_item_markers = 1

--[[
available commands:
:GenToc***
:RemoveToc
--]]
