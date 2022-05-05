-- settings
-- https://github.com/mbbill/undotree/blob/master/plugin/undotree.vim#L15

-- Style 2
-- +----------+------------------------+
-- |          |                        |
-- |          |                        |
-- | undotree |                        |
-- |          |                        |
-- |          |                        |
-- +----------+------------------------+
-- |                                   |
-- |   diff                            |
-- |                                   |
-- +-----------------------------------+
vim.g.undotree_WindowLayout = 2
-- let undo-tree window get focus after being opened
vim.g.undotree_SetFocusWhenToggle = 1
-- use 'd' as shortname instead of 'days'
vim.g.undotree_ShortIndicators = 1

-- keybindings
vim.keymap.set('n', '<A-u>', ':UndotreeToggle<CR>', {
  desc = 'toggle the undo-tree panel'
})
