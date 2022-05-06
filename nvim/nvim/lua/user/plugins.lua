--  ____  _             _
-- |  _ \| |_   _  __ _(_)_ __  ___
-- | |_) | | | | |/ _` | | '_ \/ __|
-- |  __/| | |_| | (_| | | | | \__ \
-- |_|   |_|\__,_|\__, |_|_| |_|___/
--                |___/

-- Author: @flyingice


-- https://github.com/wbthomason/packer.nvim#bootstrapping
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
end

local status, packer = pcall(require, 'packer')
if not status then
  return
end

-- https://github.com/wbthomason/packer.nvim#specifying-plugins
return packer.startup({
  function()
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

    -- markdown support
    use {
      {
        'dhruvasagar/vim-table-mode',
        ft = { 'markdown' },
      },
      {
        'mzlogin/vim-markdown-toc',
        ft = { 'markdown' },
      },
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
      ft = { 'cpp', 'java', 'python' }
    }

    -- highlighting and folding
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      ft = { 'cpp', 'lua', 'java', 'python' },
      config = function() require('user.conf.treesitter') end
    }

    -- language server protocol
    use {
      "williamboman/nvim-lsp-installer",
      {
          "neovim/nvim-lspconfig",
          config = function()
            require('user.lsp.installer')
            require('user.lsp.lspconfig')
          end
      }
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
