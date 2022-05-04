local colorscheme = 'onedark'

local status = pcall(vim.cmd, 'colorscheme '..colorscheme)
if not status then
  vim.notify('colorscheme '..colorscheme..' not found')
  return
end

-- settings
-- config doc: https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
-- recommend MesloLGS Nerd Font Mono (https://github.com/ryanoasis/nerd-fonts)
vim.g.airline_theme = colorscheme
vim.g.airline_powerline_fonts = 1
-- enable the list of buffer
vim.g['airline#extensions#tabline#enabled'] = 1
-- show buffer number
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
-- show just the filename without path
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
-- truncate non-active buffer names to specified length
vim.g['airline#extensions#tabline#fnametrucate'] = 16
