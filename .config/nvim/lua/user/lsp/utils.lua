-- Author: @flyingice

local opts = { noremap = true, silent = true }

return {
  -- generate a list of server names
  get_servers = function()
    local dir = io.popen('find -L ' .. vim.fn.stdpath('config') .. "/lua/user/lsp/servers -type f -name '*.lua'")
    if not dir then
      vim.notify('fail to locate server config path')
      return
    end

    local servers = {}
    for filename in dir:lines() do
      local basename = filename:match('[^/]*.lua$')
      table.insert(servers, basename:sub(0, #basename - 4))
    end

    return servers
  end,

  -- keybindings for LSP diagnostics
  set_keymap = function()
    local set = vim.api.nvim_set_keymap

    -- `:help vim.diagnostic.*` for documentation on any of the below functions
    set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    set('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    set('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    set('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  end,

  -- use on_attach function to only map keys after the language server attaches to the current buffer
  on_attach = function(client, bufnr)
    local buf_set = vim.api.nvim_buf_set_keymap

    -- `:help vim.lsp.*` for documentation on any of the below functions
    buf_set(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set(bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set(bufnr, 'n', '<Leader>c', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set(bufnr, 'n', '<Leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set(bufnr, 'n', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set(bufnr, 'n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  end
}
