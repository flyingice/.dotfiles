-- Author: @flyingice

--[[
https://github.com/mfussenegger/nvim-dap

configuration (:help dap.txt)
https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt

Debug Adapter installation
https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
--]]

local status = pcall(require, 'dap')
if not status then
  vim.notify('fail to load dap')
  return
end

-- settings
vim.fn.sign_define('DapBreakpoint', {
  -- U+1F534
  text = '🔴',
  texthl = '',
  linehl = '',
  numhl = '',
})

vim.fn.sign_define('DapBreakpointCondition', {
  -- U+2B55
  text = '⭕',
  texthl = '',
  linehl = '',
  numhl = '',
})

vim.fn.sign_define('DapLogPoint', {
  -- U+1F7E1
  text = '🟡',
  texthl = '',
  linehl = '',
  numhl = '',
})

-- keybindings
local set = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- nvim-dap doesn't configure any mappings by default
set('n', '<F2>', "<cmd>lua require('dap').continue()<CR>", opts)
set('n', '<F3>', "<cmd>lua require('dap').step_over()<CR>", opts)
set('n', '<F4>', "<cmd>lua require('dap').step_into()<CR>", opts)
set('n', '<F5>', "<cmd>lua require('dap').step_out()<CR>", opts)
set('n', '<F10>', "<cmd>lua require('dap').terminate()<CR>", opts)
set('n', '<Leader>db', "<cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
set('n', '<Leader>dB', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
set('n', '<Leader>dl', "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
set('n', '<Leader>do', "<cmd>lua require('dap').repl.open()<CR>", opts)
set('n', '<Leader>dr', "<cmd>lua require('dap').run_last()<CR>", opts)
