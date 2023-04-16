-- Author: @flyingice

--[[
https://github.com/williamboman/nvim-lsp-installer
--]]
local status, installer = pcall(require, 'nvim-lsp-installer')
if not status then
  vim.notify('fail to load nvim-lsp-installer')
  return
end

--[[
https://github.com/williamboman/nvim-lsp-installer#default-configuration
:LspInstallInfo to open an overview of all the language servers
--]]
local default_settings = {
  --[[
  list of servers to automatically install if they're not already installed.
  https://github.com/williamboman/nvim-lsp-installer#available-lsps
  --]]
  ensure_installed = {
  },
  --[[
  whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  false: servers are not automatically installed.
  true: all servers set up via lspconfig are automatically installed.
  { exclude: string[] }: all servers set up except the ones provided in the list, are automatically installed. e.g.,
    automatic_installation = { exclude = { 'rust_analyzer', 'solargraph' } }
  --]]
  automatic_installation = false,
  ui = {
    icons = {
      server_installed = '◍',
      server_pending = '◍',
      server_uninstalled = '◍',
    },
    keymaps = {
      -- expand a server in the UI
      toggle_server_expand = '<CR>',
      -- install the server under the current cursor position
      install_server = 'i',
      -- reinstall/update the server under the current cursor position
      update_server = 'u',
      -- check for new version for the server under the current cursor position
      check_server_version = 'c',
      -- update all installed servers
      update_all_servers = 'U',
      -- check which installed servers are outdated
      check_outdated_servers = 'C',
      -- uninstall a server
      uninstall_server = 'X',
    },
  },

  -- server install path
  install_root_dir = vim.fn.stdpath('data') .. '/lsp_servers',

  pip = {
    --[[
    args will be added to `pip install` calls.
    setting extra args might impact intended behavior and is not recommended
    e.g., { '--proxy', 'https://proxyserver' }
    --]]
    install_args = {},
  },

  --[[
  controls to which degree logs are written to the log file.
  set this to vim.log.levels.DEBUG when debugging issues with server installations.
  --]]
  log_level = vim.log.levels.INFO,

  --[[
  limit the maximum amount of servers to be installed at the same time, any further
  servers over the limit will be put in a queue.
  --]]
  max_concurrent_installers = 4,
}

installer.setup(default_settings)
