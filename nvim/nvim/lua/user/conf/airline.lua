-- Author: @flyingice

-- settings
-- config doc: https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt

vim.g.airline_theme = 'onedark'
-- recommend MesloLGS Nerd Font Mono (https://github.com/ryanoasis/nerd-fonts)
vim.g.airline_powerline_fonts = 1
-- startup with a minimalistic setup. An empty list disables all extensions.
-- :AirlineExtensions to check the list of loaded plugins
vim.g.airline_extensions = { 'tabline', 'whitespace' }
-- disable displaying tabs
vim.g['airline#extensions#tabline#show_tabs'] = 0
-- disable displaying number of tabs on the right side
vim.g['airline#extensions#tabline#show_tab_count'] = 0
-- disable displaying tab number in tabs mode
vim.g['airline#extensions#tabline#show_tab_nr'] = 0
-- highlight current active buffer like this: buffer <buffer> buffer
vim.g['airline#extensions#tabline#alt_sep'] = 1
-- show buffer label at first position
vim.g['airline#extensions#tabline#buf_label_first'] = 1
-- display buffer numbers (mappings <Leader>0..9 are created below)
vim.g['airline#extensions#tabline#buffer_idx_mode'] = 1
-- show just the filename without path
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
-- truncate non-active buffer names to specified length
vim.g['airline#extensions#tabline#fnametrucate'] = 16

-- keybindings
for i = 0, 9 do
  vim.keymap.set('n', '<Leader>' .. i, '<Plug>AirlineSelectTab' .. i, {
    desc = 'go to buffer ' .. i
  })
end
