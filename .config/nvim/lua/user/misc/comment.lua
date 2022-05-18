-- Author: @flyingice

--[[
https://github.com/numToStr/Comment.nvim
--]]
local status, comment = pcall(require, 'Comment')
if not status then
  vim.notify('fail to load Comment.nvim')
  return
end

-- override default config
comment.setup({
  -- add a space b/w comment and the line
  padding = true,
  --[[
  whether the cursor should stay at its position
  it only affects NORMAL mode mappings and doesn't work with dot-repeat
  --]]
  sticky = true,
  --[[
  lines to be ignored while comment/uncomment.
  could be a regex string or a function that returns a regex string. e.g.,
  '^$' to ignore empty lines
  --]]
  ignore = nil,
  -- toggle mappings in NORMAL + VISUAL mode
  toggler = {
    -- line-comment toggle keymap
    line = 'gcc',
    -- block-comment toggle keymap
    block = 'gbc',
  },
  -- operator-pending mappings in NORMAL + VISUAL mode
  opleader = {
    -- line-comment keymap
    line = 'gc',
    -- block-comment keymap
    block = 'gb',
  },
  -- extra mappings
  extra = {
    -- add comment on the line above
    above = 'gcO',
    -- add comment on the line below
    below = 'gco',
    -- add comment at the end of line
    eol = 'gcA',
  },
  -- create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
  -- if `mappings = false` then the plugin won't create any mappings
  mappings = {
    --[[
    operator-pending mapping
    includint `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
    --]]
    basic = true,
    --[[
    extra mapping
    including `gco`, `gcO`, `gcA`
    --]]
    extra = true,
    --[[
    extended mapping
    includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    --]]
    extended = false,
  },
  -- pre-hook, called before commenting the line
  pre_hook = nil,
  -- post-hook, called after commenting is done
  post_hook = nil,
})
