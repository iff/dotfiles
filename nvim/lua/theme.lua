vim.opt.background = 'dark'
vim.cmd('syntax enable')

-- vim.cmd('colorscheme gruvbox')
require('nightfox').load('nordfox')
--require('nightfox').load('dawnfox')

-- lualine
-- require('lualine').setup {options = { theme = 'gruvbox' }}
-- require('lualine').setup {options = { theme = 'nightfox' }}
require('nvim-web-devicons').setup {}

require('lualine').setup {
  options = {
    theme = 'gruvbox',
    icons_enabled = false,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'quickfix'}
}
