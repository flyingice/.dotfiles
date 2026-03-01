-- Author: @flyingice

--[[
https://github.com/akinsho/bufferline.nvim
--]]
local status, bufferline = pcall(require, 'bufferline')
if not status then
    vim.notify('fail to load bufferline.nvim')
    return
end

bufferline.setup({
    options = {
        -- show buffer index for quick switching
        numbers = 'ordinal',
        -- show just the filename without path
        name_formatter = function(buf)
            return vim.fn.fnamemodify(buf.name, ':t')
        end,
        -- truncate names
        max_name_length = 16,
        -- show tabs as buffers only
        mode = 'buffers',
        -- show whitespace indicator
        show_buffer_close_icons = false,
        show_close_icon = false,
    },
})

-- keybindings: <Leader>1..9 to jump to buffer by visible position
for i = 1, 9 do
    vim.keymap.set('n', '<Leader>' .. i, function()
        bufferline.go_to(i, true)
    end, { desc = 'go to buffer ' .. i })
end
