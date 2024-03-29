-- Author: @flyingice

--[[
https://github.com/rcarriga/nvim-dap-ui#readme
--]]
local status_depui, dapui = pcall(require, 'dapui')
if not status_depui then
  vim.notify('fail to load nvim-dap-ui')
  return
end

-- load dependency
local status_dap, dap = pcall(require, 'dap')
if not status_dap then
  vim.notify('fail to load nvim-dap')
  return
end

-- keybindings
local set = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

set('n', '<Leader>dk', "<cmd>lua require('dapui').eval()<CR>", opts)

--[[
use nvim-dap events to open and close the window automatically (:help dap-extensions)
specification of events:
https://microsoft.github.io/debug-adapter-protocol/specification#Events
--]]
local debug_close = function()
  dapui.close()
  -- close repl window
  dap.repl.close()
  -- close terminal
  vim.api.nvim_command('silent! bdelete! term:')
end

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  debug_close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  debug_close()
end

dapui.setup({
  icons = { expanded = '▾', collapsed = '▸' },
  mappings = {
    -- use a table to apply multiple mappings
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  -- expand lines larger than the window
  expand_lines = vim.fn.has('nvim-0.7'),
  layouts = {
    {
      -- change the order of elements in the sidebar
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40,
      -- can be 'left', 'right', 'top', 'bottom'
      position = 'left',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 10,
      -- can be 'left', 'right', 'top', 'bottom'
      position = 'bottom',
    },
  },
  floating = {
    -- can be integers or a float between 0 and 1
    max_height = nil,
    -- floats will be treated as percentage of your screen
    max_width = nil,
    -- can be 'single', 'double' or 'rounded'
    border = 'single',
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  windows = { indent = 1 },
  render = {
    -- can be integer or nil
    max_type_length = nil,
  }
})
