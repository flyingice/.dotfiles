--  ____  _             _
-- |  _ \| |_   _  __ _(_)_ __  ___
-- | |_) | | | | |/ _` | | '_ \/ __|
-- |  __/| | |_| | (_| | | | | \__ \
-- |_|   |_|\__,_|\__, |_|_| |_|___/
--                |___/

-- Author: @flyingice


-- https://github.com/wbthomason/packer.nvim#bootstrapping
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
end

local status, packer = pcall(require, 'packer')
if not status then
  return
end

local languages = { 'cpp', 'lua', 'java', 'python', 'sh', }

-- https://github.com/wbthomason/packer.nvim#specifying-plugins
return packer.startup({
  function(use)
    -- require packer itself,
    -- otherwise a prompt window would appear asking whether to remove packer directory
    use { 'wbthomason/packer.nvim' }

    -- enhance netrw shipped with vim
    use {
      'tpope/vim-vinegar',
      config = function() require('user.conf.netrw') end
    }

    -- provide mapping to easily delete, change and add surroudings in paris
    use 'tpope/vim-surround'

    -- comment out the target of a motion
    use 'tpope/vim-commentary'

    -- richer text objects support
    use 'wellle/targets.vim'

    -- fuzzy finder
    use {
      'junegunn/fzf.vim',
      requires = {
        'junegunn/fzf',
        run = vim.fn['fzf#install'],
      },
      config = function() require('user.conf.fzf') end
    }

    -- visualize undo history and switch between different undo branches
    use {
      'mbbill/undotree',
      config = function() require('user.conf.undotree') end
    }

    -- persist and toggle multiple terminals
    use {
      'akinsho/toggleterm.nvim',
      config = function() require('user.conf.toggleterm') end
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
        ft = { 'markdown' },
        config = function() require('user.conf.markdown') end
      }
    }

    -- line up text
    use {
      'godlygeek/tabular',
      config = function() require('user.conf.tabular') end
    }

    -- display thin vertical lines at each indentation level
    use {
      'Yggdroot/indentLine',
      ft = languages,
      config = function() require('user.conf.indentline') end
    }

    -- add pairs automatically
    use {
      'windwp/nvim-autopairs',
      config = function() require('user.conf.autopairs') end
    }

    -- highlighting and folding
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      disable = true,
      ft = languages,
      config = function() require('user.conf.treesitter') end
    }

    -- language server protocol
    use {
      -- install language servers
      'williamboman/nvim-lsp-installer',
      -- collection of configurations for built-in LSP client
      {
        'neovim/nvim-lspconfig',
        disable = true,
        config = function()
          require('user.lsp.installer')
          require('user.lsp')
        end
      },
      -- non built-in autocompletion
      {
        'hrsh7th/nvim-cmp',
        disable = true,
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
        config = function() require('user.lsp.cmp') end,
      },
    }

    -- debug adapter protocol
    use {
      -- DAP client implementation
      {
        'mfussenegger/nvim-dap',
        ft = languages,
        config = function() require('user.dap') end
      },
      -- UI extension for nvim-dap
      {
        'rcarriga/nvim-dap-ui',
        ft = languages,
        config = function() require('user.dap.dapui') end
      },
      -- virtual text support to nvim-dap
      {
        'theHamsta/nvim-dap-virtual-text',
        ft = languages,
        config = function() require('user.dap.dapvt') end
      },
      -- nvim-dap extension providing default debug configurations for python
      {
        'mfussenegger/nvim-dap-python',
        ft = 'python',
        after = 'nvim-dap',
        config = function() require('user.dap.langs.python') end
      },
    }

    -- nice statuline
    use {
      'vim-airline/vim-airline-themes',
      {
        'vim-airline/vim-airline',
        config = function() require('user.conf.airline') end
      }
    }

    -- colorscheme
    -- better support for neovim treesitter highlighting
    use {
      'navarasu/onedark.nvim',
      config = function() require('user.conf.theme') end
    }

    -- automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
      packer.sync()
    end

  end,
  config = {
    git = {
      -- accelerate git access if behind the Great Firewall
      default_url_format = 'https://hub.fastgit.xyz/%s'
    },
    display = {
      -- configure Packer to use a floating window
      open_fn = require('packer.util').float
    }
  }
})