--[[
 ____  _             _
|  _ \| |_   _  __ _(_)_ __
| |_) | | | | |/ _` | | '_ \
|  __/| | |_| | (_| | | | | |
|_|   |_|\__,_|\__, |_|_| |_|
               |___/

Author: @flyingice

https://github.com/wbthomason/packer.nvim

--]]

--[[
https://github.com/wbthomason/packer.nvim#bootstrapping
--]]
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
-- customize url if being blocked by Great Firewall. e.g., https://hub.fastgit.xyz
local url_prefix = 'https://github.com'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system { 'git', 'clone', '--depth', '1', url_prefix .. '/wbthomason/packer.nvim', install_path }
end

local status, packer = pcall(require, 'packer')
if not status then
  vim.notify('fail to load packer.nvim')
  return
end

-- some plugins are lazy loaded based on file format
local langs_enabled = { 'cpp', 'lua', 'java', 'python', 'sh', }

--[[
https://github.com/wbthomason/packer.nvim#specifying-plugins
--]]
return packer.startup({
  function(use)
    -- load packer itself
    use { 'wbthomason/packer.nvim' }

    -- file explorer
    use {
      'kyazdani42/nvim-tree.lua',
      keys = { 'n', '<A-t>' },
      config = function() require('user.misc.explorer') end
    }
    -- provide mapping to easily delete, change and add surroudings in paris
    use 'tpope/vim-surround'

    -- comment out the target of a motion
    use {
      'numToStr/Comment.nvim',
      ft = langs_enabled,
      config = function() require('user.misc.comment') end
    }

    --[[
    richer text-objects support
    add a(rgument), q(uote) and b(lock) as text-objects
    seek forward (default) with n, backward with l
    numbers accepted, e.g., c2ina
    --]]
    use 'wellle/targets.vim'

    -- fuzzy finder
    use {
      'junegunn/fzf.vim',
      requires = {
        'junegunn/fzf',
        run = vim.fn['fzf#install'],
      },
      config = function() require('user.misc.fzf') end
    }

    -- visualize undo history and switch between different undo branches
    use {
      'mbbill/undotree',
      config = function() require('user.misc.undotree') end
    }

    -- persist and toggle multiple terminals
    use {
      'akinsho/toggleterm.nvim',
      config = function() require('user.misc.toggleterm') end
    }

    -- markdown support
    use {
      -- automatic table creator and formatter
      { 'dhruvasagar/vim-table-mode', ft = 'markdown' },
      -- generate table of contents for markdown files
      { 'mzlogin/vim-markdown-toc', ft = 'markdown' },
      -- live preview of markdown files
      {
        'instant-markdown/vim-instant-markdown',
        ft = 'markdown',
        config = function() require('user.misc.markdown') end
      }
    }

    -- line up text
    use {
      'godlygeek/tabular',
      config = function() require('user.misc.tabular') end
    }

    -- display vertical lines at each indentation level
    use {
      'lukas-reineke/indent-blankline.nvim',
      ft = langs_enabled,
      config = function() require('user.misc.indentline') end
    }

    -- add pairs automatically
    use {
      'windwp/nvim-autopairs',
      config = function() require('user.misc.autopairs') end
    }

    -- treesitter
    use {
      -- core
      {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        ft = langs_enabled,
        config = function() require('user.treesitter') end
      },
      --[[
      extra treesitter modules
      --]]
      -- syntax aware text-ojbects, configured in treesitter/textobjects.lua
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        ft = langs_enabled
      },
      -- show current function context
      {
        'nvim-treesitter/nvim-treesitter-context',
        ft = langs_enabled,
        config = function() require('user.treesitter.context') end
      }
    }

    -- language server protocol
    use {
      -- language servers installer
      'williamboman/nvim-lsp-installer',
      -- collection of configurations for built-in LSP client
      {
        'neovim/nvim-lspconfig',
        config = function()
          require('user.lsp.installer')
          require('user.lsp')
        end
      },
      -- non built-in autocompletion
      {
        'hrsh7th/nvim-cmp',
        requires = {
          -- LSP source for nvim-cmp
          'hrsh7th/cmp-nvim-lsp',
          -- function signature source for nvim-cmp
          'hrsh7th/cmp-nvim-lsp-signature-help',
          -- snippets plugin
          'L3MON4D3/LuaSnip',
          -- snippets source for nvim-cmp
          'saadparwaiz1/cmp_luasnip',
          'rafamadriz/friendly-snippets',
        },
        config = function() require('user.lsp.autocomplete') end
      },
      --[[
      use Neovim as a languager server to inject LSP diagnostics, code actions and more
      Here it is used to hook into code formatting only since not all language servers
      provide such feature. e.g., clangd, jdtls, sumneko_lua have built-in support for
      code formatting while bashls and pyright don't as of May 2022
      check related issue of bashls:
      https://github.com/bash-lsp/bash-language-server/issues/104
      --]]
      {
        'jose-elias-alvarez/null-ls.nvim',
        -- serve as null-ls dependency
        requires = {
          'nvim-lua/plenary.nvim',
        },
        ft = { 'python', 'sh', },
        config = function() require('user.lsp.null-ls') end
      },
      -- language specific
      --[[
      extensions for built-in LSP support for jdtls
      It is required to support jumping to external libraries:
      https://github.com/neovim/nvim-lspconfig/issues/784
      --]]
      { 'mfussenegger/nvim-jdtls', ft = 'java' },
    }

    -- debug adapter protocol
    use {
      -- DAP client implementation
      {
        'mfussenegger/nvim-dap',
        ft = langs_enabled,
        config = function() require('user.dap') end
      },
      -- UI extension for nvim-dap
      {
        'rcarriga/nvim-dap-ui',
        after = 'nvim-dap',
        config = function() require('user.dap.ui') end
      },
      -- virtual text support to nvim-dap
      {
        'theHamsta/nvim-dap-virtual-text',
        after = 'nvim-dap',
        config = function() require('user.dap.virtual-text') end
      },
      -- nvim-dap extension providing default debug configurations for python
      {
        'mfussenegger/nvim-dap-python',
        after = 'nvim-dap',
        config = function() require('user.dap.langs.python') end
      },
    }

    -- nice statuline
    use {
      'vim-airline/vim-airline-themes',
      {
        'vim-airline/vim-airline',
        config = function() require('user.misc.airline') end
      }
    }

    -- colorscheme
    -- better support for neovim treesitter highlighting
    use {
      'navarasu/onedark.nvim',
      config = function() require('user.misc.theme') end
    }

    -- automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
      packer.sync()
    end

  end,
  config = {
    git = {
      default_url_format = url_prefix .. '/%s'
    },
    display = {
      -- configure Packer to use a floating window
      open_fn = require('packer.util').float
    }
  }
})
