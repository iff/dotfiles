-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

require('theme').plugs()

Plug('numToStr/Comment.nvim')
require('my/hop').plugs()
require('my/autosave').plugs()
require('my/funky').plugs()

require('my/git').plugs()

require('my/treesitter').plugs()

require('my/telescope').plugs()
require('my/lspconfig').plugs()

Plug('dkuettel/funky-contexts.nvim')

vim.call('plug#end')

require('funky-contexts').setup()
