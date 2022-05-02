--  ____       _   _   _
-- / ___|  ___| |_| |_(_)_ __   __ _ ___
-- \___ \ / _ \ __| __| | '_ \ / _` / __|
--  ___) |  __/ |_| |_| | | | | (_| \__ \
-- |____/ \___|\__|\__|_|_| |_|\__, |___/
--                             |___/


-- https://neovim.io/doc/user/vim_diff.html#nvim-defaults

local options = {
    number = true,
    relativenumber = true,
    cursorline = true,
    showmode = true,
    tabstop = 4,
    shiftwidth = 4,
    smartindent = true,
    hidden = true,
    ignorecase = true,
    smartcase = true,
    infercase = true,
    scrolloff = 5,
    mouse = "a",
    foldmethod = "indent",
    timeoutlen = 1000,
    ttimeoutlen = 0,
    termguicolors = true,
}

vim.opt.shortmess:append "I"

for key, value in pairs(options) do
    vim.opt[key] = value
end

vim.cmd [[
 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]
