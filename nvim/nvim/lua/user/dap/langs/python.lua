-- Author: @flyingice

local status, dappy = pcall(require, 'dap-python')
if not status then
  vim.notify('fail to load dap-python')
  return
end

--[[
https://github.com/mfussenegger/nvim-dap-python

configuration:
https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
--]]
dappy.setup(vim.fn.stdpath('data') .. '/debugger/debugpy/bin/python')
