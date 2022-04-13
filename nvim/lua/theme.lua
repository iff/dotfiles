vim.opt.background = 'dark'
vim.cmd('syntax enable')

-- vim.cmd('colorscheme gruvbox')
vim.cmd('colorscheme nordfox')
-- vim.cmd('colorscheme dawnfox')

-- lualine
-- require('lualine').setup {options = { theme = 'gruvbox' }}
-- require('lualine').setup {options = { theme = 'nightfox' }}
require('nvim-web-devicons').setup {}

function window_nr()
    return "#" .. vim.api.nvim_win_get_number(0)
end

require('lualine').setup {
  options = {
    theme = 'nightfox',
    icons_enabled = false,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { window_nr },
    lualine_b = {'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = { window_nr },
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'quickfix'}
}
