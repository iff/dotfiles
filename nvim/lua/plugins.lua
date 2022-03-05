-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

-- colors for vim
Plug('morhetz/gruvbox')             -- colors for vim
Plug('EdenEast/nightfox.nvim', { ['branch'] = 'main' })
-- Plug 'npxbr/gruvbox.nvim', { 'branch': 'main' }

Plug 'sjl/gundo.vim'                -- undo history tree

Plug 'nvim-lualine/lualine.nvim'    -- bottom bar
Plug 'kyazdani42/nvim-web-devicons' -- If you want to have icons in your statusline choose one of these

Plug 'tpope/vim-sleuth'             -- heuristically set buffer options
Plug 'tpope/vim-surround'           -- surround with brackets, quotes, ...
Plug 'scrooloose/nerdcommenter'

Plug 'easymotion/vim-easymotion'    -- the only movement command you will ever use
-- Plug 'phaazon/hop.nvim'

-- Git plugins
Plug 'airblade/vim-gitgutter'       -- show unstaged edits
Plug 'tpope/vim-fugitive'           -- many git helpers
-- Plug 'int3/vim-extradite'           -- git commit browser

Plug('numirias/semshi', {['do'] = ':UpdateRemotePlugins'})        -- python syn-tactic highlighting
-- Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'sbdchd/neoformat'                                           -- formatter
Plug('Shougo/deoplete.nvim', { ['do'] = ':UpdateRemotePlugins'})  -- autocomplete on steroids

Plug '~/.dotfiles/bootstrap/nvim/vimminent'
Plug '~/.dotfiles/bootstrap/pdocs/pdocs'

vim.call('plug#end')
