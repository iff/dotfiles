-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

-- colors for vim
Plug('morhetz/gruvbox')
Plug('EdenEast/nightfox.nvim', { ['branch'] = 'main' })

Plug 'kyazdani42/nvim-web-devicons' -- icons
Plug 'nvim-lualine/lualine.nvim'

-- Plug 'tpope/vim-surround'

Plug 'numToStr/Comment.nvim'

Plug 'phaazon/hop.nvim'

-- Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

Plug 'Pocco81/AutoSave.nvim'

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'fannheyward/telescope-coc.nvim'

Plug('neoclide/coc.nvim', {['branch'] = 'release'})

Plug 'sbdchd/neoformat'

vim.call('plug#end')
