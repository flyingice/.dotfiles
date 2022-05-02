--  _  __
-- | |/ /___ _   _ _ __ ___   __ _ _ __  ___
-- | ' // _ \ | | | '_ ` _ \ / _` | '_ \/ __|
-- | . \  __/ |_| | | | | | | (_| | |_) \__ \
-- |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
--           |___/                |_|


local opts = {
	noremap = true,
	silent = true
}

local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

keymap("", "s", "<Nop>", opts)

keymap("i", "<S-Tab>", "<C-d>", opts)

keymap("n", "<C-q>", "<C-a>", opts)

keymap("n", "S", ":w<CR>", opts)
keymap("n", "Q", ":q<CR>", opts)

keymap("n", "oo", "o<Esc>k", opts)
keymap("n", "OO", "O<Esc>j", opts)

keymap("n", "sh", ":set nosplitright<CR>:vsplit<CR>", opts)
keymap("n", "sl", ":set splitright<CR>:vsplit<CR>", opts)
keymap("n", "sk", ":set nosplitbelow<CR>:split<CR>", opts)
keymap("n", "sj", ":set splitbelow<CR>:split<CR>", opts)

keymap("n", "[b", ":bprevious<CR>", opts)
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[B", ":bfirst<CR>", opts)
keymap("n", "]B", ":blast<CR>", opts)

keymap("n", "[q<CR>", ":cprevious<CR>", opts)
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[Q", ":cfirst<CR>", opts)
keymap("n", "]Q", ":clast<CR>", opts)

keymap("n", "[l<CR>", ":lprevious<CR>", opts)
keymap("n", "]l", ":lnext<CR>", opts)
keymap("n", "[L", ":lfirst<CR>", opts)
keymap("n", "]L", ":llast<CR>", opts)

keymap("n", "<A-s>", ":term<CR>a", opts)

keymap("n", "<A-g>", ":term lazygit<CR>a", opts)

keymap("t", "<Esc>", "<C-\\><C-n>", opts)
