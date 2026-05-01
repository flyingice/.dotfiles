-- Author: @flyingice

-- code folding (main branch uses the built-in vim.treesitter.foldexpr)
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
