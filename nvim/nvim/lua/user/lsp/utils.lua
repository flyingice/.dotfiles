-- Author: @flyingice

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
  end
}
