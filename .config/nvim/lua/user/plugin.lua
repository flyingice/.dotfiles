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
        branch = 'main',
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
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        -- syntax aware text-ojbects, configured in treesitter/textobjects.lua
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        -- show current function context
        { "nvim-treesitter/nvim-treesitter-context" },
      },
      config = function()
        require('user.treesitter')
        require("user.treesitter.context")
      end
    }

    -- nice statusline
    use {
      'nvim-lualine/lualine.nvim',
      config = function() require('user.misc.statusline') end
    }

    -- buffer tabline with index-based switching
    use {
      'akinsho/bufferline.nvim',
      config = function() require('user.misc.bufferline') end
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
