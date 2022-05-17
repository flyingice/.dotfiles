-- Author: @flyingice

-- https://github.com/kyazdani42/nvim-tree.lua
local status, explorer = pcall(require, 'nvim-tree')
if not status then
  vim.notify('fail to load nvim-tree')
  return
end

explorer.setup {
  -- can be name | case_sensitive | modification_time | extension
  sort_by = 'name',
  -- change the tree root directory on DirChanged and refreshes the tree
  update_cwd = true,
  update_focused_file = {
    -- update the focused file on BufEnter, un-collapse the folder until it finds the file
    enable = true,
  },
  filters = {
    -- hide dotfiles
    dotfiles = true,
    -- custom list of vim regex for file/directory names that will not be shown
    custom = {},
    -- list of directories to exclude from filtering
    exclude = {},
  },
  view = {
    -- can be left | right | bottom | top
    side = 'left',
    mappings = {
      -- use only provided user mappings specified in the below list
      custom_only = true,
      -- keybindings are consistent with those of ranger file manager
      list = {
        { key = '<CR>', action = 'edit' },
        { key = 'l', action = 'cd' },
        { key = 'h', action = 'dir_up' },
        { key = { '[', ']' }, action = 'parent_node' },
        { key = 'yp', action = 'copy_absolute_path' },
        { key = 'yn', action = 'copy_name' },
        { key = '-', action = 'collapse_all' },
        { key = 'r', action = 'refresh' },
        { key = 'cw', action = 'rename' },
        { key = 'dD', action = 'remove' },
        { key = '.', action = 'run_file_command' },
        { key = 'zh', action = 'toggle_dotfiles' },
        { key = '?', action = 'toggle_help' },
        { key = 'q', action = 'close' },
      },
    }
  },
  actions = {
    -- store copied text in register +
    use_system_clipboard = true,
  },
  renderer = {
    indent_markers = {
      -- disable indent markers when folders are open
      enable = false,
    },
    icons = {
      -- use nvim-tree default file icon
      webdev_colors = false,
    }
  },
  git = {
    -- disable git integration with icons and colors
    enable = false,
  },
  log = {
    -- disable logging to file $XDG_CACHE_HOME/nvim/nvim-tree.log
    enable = false,
  }
}

-- keybindings
vim.keymap.set('n', '<A-t>', ':NvimTreeToggle<CR>', {
  desc = 'toggle file explorer'
})
