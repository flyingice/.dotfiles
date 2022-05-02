--  ____  _             _
-- |  _ \| |_   _  __ _(_)_ __  ___
-- | |_) | | | | |/ _` | | '_ \/ __|
-- |  __/| | |_| | (_| | | | | \__ \
-- |_|   |_|\__,_|\__, |_|_| |_|___/
--                |___/


local opts = {
	noremap = true,
	silent = true,
}

local keymap = vim.api.nvim_set_keymap

--
-- matchit is enabled by default
--

--
-- netrw
--

vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

keymap('n', '<A-t>', ':Vexplore<CR>', opts)


keymap('n', '<A-b>', ':Buffers<CR>', opts)
keymap('n', '<A-f>', ':Files<CR>', opts)
keymap('n', '<A-h>', ':History<CR>', opts)
keymap('n', '<A-r>', ':Rg<CR>', opts)


vim.cmd('silent! colorscheme onedark')

vim.g.airline_theme = 'onedark'
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
vim.g['airline#extensions#tabline#fnametrucate'] = 16

--
-- packer
--


if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
	packer_bootstrap = vim.fn.system {
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/wbthomason/packer.nvim',
		vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	}
	vim.cmd [[ packadd packer.nvim ]]
end

local status, packer = pcall(require, 'packer')
if not status then
	return
end


return packer.startup(function()
	use "wbthomason/packer.nvim"

	use 'tpope/vim-vinegar'

	use 'tpope/vim-surround'

	use 'tpope/vim-commentary'

	use { 'junegunn/fzf', run = vim.fn['fzf#install'] }
	use 'junegunn/fzf.vim'

	use { 'vim-airline/vim-airline' }
	use { 'vim-airline/vim-airline-themes' }

	use { 'joshdick/onedark.vim' }
	use { 'arzg/vim-colors-xcode' }

	if packer_bootstrap then
		-- require('packer').sync()
	end
end)
