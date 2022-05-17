-- Author: @flyingice

-- https://github.com/mfussenegger/nvim-jdtls#configuration
local status, jdtls = pcall(require, 'jdtls')
if not status then
  vim.notify('fail to load nvim-jdtls')
  return
end

local home = os.getenv('HOME')
local data_home = home .. '/.local/share'
local jdtls_dir = data_home .. '/nvim/lsp_servers/jdtls'
local root_markers = { '.git', 'pom.xml', }
local root_dir = require('jdtls.setup').find_root(root_markers)
local workspace_dir = data_home .. '/java-workspace/' .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  --[[
  command that starts the language server
  https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  --]]
  cmd = {
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',

    '-configuration', jdtls_dir .. '/config_mac',

    '-data', workspace_dir,
  },

  -- one dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  --[[
  here you can configure eclipse.jdt.ls specific settings
  for a list of options:
  https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  --]]
  settings = {
    java = {
    }
  },

  --[[
  language server `initializationOptions`
  you need to extend the `bundles` with paths to jar files
  if you want to use additional eclipse.jdt.ls plugins, see
  https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  --]]
  init_options = {
    bundles = {}
  },

  -- keybindings
  on_attach = function(client, bufnr)
    -- LSP baseline keybindings
    require('user.lsp.utils').on_attach(client, bufnr)

    -- keybindings for jdtls extended capabilities
    local buf_set = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true }

    buf_set(bufnr, 'n', '<Leader>i', "<cmd>lua require('jdtls').organize_imports()<CR>", opts)
  end
}

-- start a new client & server or attaches to an existing one depending on the `root_dir`.
jdtls.start_or_attach(config)
