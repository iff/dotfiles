-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

vim.call('plug#end')
