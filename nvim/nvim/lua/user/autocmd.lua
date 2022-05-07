--     _         _                           _
--    / \  _   _| |_ ___   ___ _ __ ___   __| |
--   / _ \| | | | __/ _ \ / __| '_ ` _ \ / _` |
--  / ___ \ |_| | || (_) | (__| | | | | | (_| |
-- /_/   \_\__,_|\__\___/ \___|_| |_| |_|\__,_|

-- Author: @flyingice


local create_group = vim.api.nvim_create_augroup
local create_cmd = vim.api.nvim_create_autocmd

local options = {
  clear = true,
}

local augroup_cursor_position = create_group('cursor_position', options)
create_cmd('BufReadPost', {
  pattern = '*',
  group = augroup_cursor_position,
  desc = 'restore cursor position at the next file reopen',
  callback = function()
    vim.cmd [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
  end
})

-- https://github.com/wbthomason/packer.nvim#quickstart
local augroup_packer_user_config = create_group('packer_user_config', options)
create_cmd('BufWritePost', {
  pattern = 'plugins.lua',
  group = augroup_packer_user_config,
  desc = 'recompile packer whenever plugins.lua is updated',
  command = 'source <afile> | PackerCompile'
})

local augroup_foldopen = create_group('foldopen', options)
create_cmd('BufWinEnter', {
  pattern = '*',
  group = augroup_foldopen,
  desc = 'open all folds',
  command = 'silent! %foldopen!'
})
