-- Author: @flyingice

--[[
https://github.com/mfussenegger/nvim-dap-python

configuration:
https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
--]]
local status, dappy = pcall(require, 'dap-python')
if not status then
  vim.notify('fail to load nvim-dap-python')
  return
end

dappy.setup(vim.fn.stdpath('data') .. '/debugger/debugpy/bin/python')
