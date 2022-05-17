--[[
 __  ____   ____     _____ __  __ ____   ____
|  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
| |\/| |\ V /  \ \ / / | || |\/| | |_) | |
| |  | | | |    \ V /  | || |  | |  _ <| |___
|_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|

Author: @flyingice

--]]

if vim.fn.has('nvim-0.7') == 0 then
  vim.notify('please upgrade neovim to 0.7 or newer version')
  return
end

require 'user.autocmd'
require 'user.option'
require 'user.keymap'
require 'user.plugin'
