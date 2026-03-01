-- Author: @flyingice

--[[
https://github.com/nvim-lualine/lualine.nvim
--]]
local status, lualine = pcall(require, 'lualine')
if not status then
    vim.notify('fail to load lualine.nvim')
    return
end

lualine.setup({
    options = {
        theme = 'onedark',
        -- JetBrainsMono Nerd Font recommended
        -- https://github.com/ryanoasis/nerd-fonts
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { { 'filename', path = 0 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    extensions = {},
})
