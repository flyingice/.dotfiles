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
      config = function() require('conf.netrw') end
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
      config = function() require('conf.fzf') end
    }

    -- visualize undo history and switch between different undo branches
    use {
      'mbbill/undotree',
      config = function() require('conf.undotree') end
    }

    -- plugin for calling lazygit from within neovim
    use {
      'kdheepak/lazygit.nvim',
      cmd = 'LazyGit',
      config = function() require('conf.lazygit') end
    }

    -- markdown support
    use {
      -- automatic table creator and formatter
      {
        'dhruvasagar/vim-table-mode',
        ft = { 'markdown' },
      },
      -- generate table of contents for markdown files
      {
        'mzlogin/vim-markdown-toc',
        ft = { 'markdown' },
      },
      -- live preview of markdown files
      {
        'instant-markdown/vim-instant-markdown',
        ft = { 'markdown' },
        config = function() require('conf.markdown') end
      }
    }

    -- line up text
    use {
      'godlygeek/tabular',
      config = function() require('conf.tabular') end
    }

    -- display thin vertical lines at each indentation level
    use {
      'Yggdroot/indentLine',
      ft = languages
    }

    -- highlighting and folding
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      ft = languages,
      config = function() require('conf.treesitter') end
    }

    -- language server protocol
    use {
      -- install language servers
      'williamboman/nvim-lsp-installer',
      -- collection of configurations for built-in LSP client
      {
        'neovim/nvim-lspconfig',
        config = function()
          require('lsp.installer')
          require('lsp.lspconfig')
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
        config = function() require('lsp.cmp') end,
      },
    }

    -- debug adapter protocol
    use {
      -- DAP client implementation
      {
        'mfussenegger/nvim-dap',
        config = function() require('dap.dap') end
      },
      -- UI extension for nvim-dap
      {
        'rcarriga/nvim-dap-ui',
        ft = languages,
        config = function() require('dap.dapui') end
      },
      -- virtual text support to nvim-dap
      {
        'theHamsta/nvim-dap-virtual-text',
        ft = languages,
        config = function () require('dap.dapvt') end
      },
      -- nvim-dap extension providing default debug configurations for python
      {
        'mfussenegger/nvim-dap-python',
        ft = { 'python' },
        config = function () require('dap.langs.python') end
      },
    }

    -- nice statuline
    use {
      'vim-airline/vim-airline-themes',
      {
        'vim-airline/vim-airline',
        config = function() require('conf.airline') end
      }
    }

    -- colorscheme
    -- better support for neovim treesitter highlighting
    use {
      'navarasu/onedark.nvim',
      config = function() require('conf.theme') end
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
