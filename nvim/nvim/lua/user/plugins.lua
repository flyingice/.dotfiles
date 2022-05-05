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
    use { 'tpope/vim-vinegar' }
    require('user.conf.netrw')

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
      'instant-markdown/vim-instant-markdown',
      ft = { 'markdown' },
      config = function() require('user.conf.markdown') end
    }
    use {
      'dhruvasagar/vim-table-mode',
      ft = { 'markdown' }
    }
    use {
      'mzlogin/vim-markdown-toc',
      ft = { 'markdown' }
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

    -- nice statuline at the bottom
    use { 'vim-airline/vim-airline-themes' }
    use {
      'vim-airline/vim-airline',
      config = function() require('user.conf.airline') end
    }

    -- colorscheme
    use { 'joshdick/onedark.vim' }

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
