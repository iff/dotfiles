vim.opt.background = 'dark'
vim.cmd('syntax enable')

-- vim.cmd('colorscheme gruvbox')
require('nightfox').load('nordfox')
--require('nightfox').load('dawnfox')

-- lualine
require('lualine').setup {options = { theme = 'nightfox' }}
require('nvim-web-devicons').setup {}

