local status, theme = pcall(require, 'onedark')
if not status then
  vim.notify('theme '..theme..' not found')
  return
end

-- https://github.com/navarasu/onedark.nvim#default-configuration
theme.setup  {
  -- choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  style = 'warm',
  -- show/hide background
  transparent = false,
  -- change terminal color as per the selected theme style
  term_colors = true,
  -- show the end-of-buffer tildes, hidden by default
  ending_tildes = false,
  -- reverse item kind highlights in cmp menu
  cmp_itemkind_reverse = false,
  -- disable default keybinding to toggle theme style
  toggle_style_key = '<NOP>',
  -- list of styles to toggle between
  toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'},

  --[[
  change code style
  options are italic, bold, underline, none
  You can configure multiple style with comma seperated, e.g., keywords = 'italic, bold'
  --]]
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },

  -- custom highlights
  -- override default colors
  colors = {},
  -- override highlight groups
  highlights = {},

  -- plugins config
  diagnostics = {
    -- darker colors for diagnostic
    darker = true,
    -- use undercurl instead of underline for diagnostics
    undercurl = true,
    -- use background color for virtual text
    background = true,
  },
}

theme.load()
