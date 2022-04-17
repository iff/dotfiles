-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

require"theme".plugs()

Plug 'numToStr/Comment.nvim'
require"my/hop".plugs()
require"my/autosave".plugs()
require"my/neoformat".plugs()

require"my/git".plugs()

require"my/treesitter".plugs()

require"my/telescope".plugs()
require"my/coc".plugs()

vim.call('plug#end')
