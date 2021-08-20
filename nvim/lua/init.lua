-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

Plug('morhetz/gruvbox')             -- colors for vim
Plug 'sjl/gundo.vim'                -- undo history tree
Plug 'vim-airline/vim-airline'      -- bottom bar
Plug 'tpope/vim-sleuth'             -- heuristically set buffer options
Plug 'tpope/vim-surround'           -- surround with brackets, quotes, ...
Plug 'easymotion/vim-easymotion'    -- the only movement command you will ever use
Plug 'scrooloose/nerdcommenter'

-- Git plugins
Plug 'airblade/vim-gitgutter'       -- show unstaged edits
Plug 'tpope/vim-fugitive'           -- many git helpers
Plug 'int3/vim-extradite'           -- git commit browser

Plug('numirias/semshi', {['do'] = ':UpdateRemotePlugins'})        -- python syn-tactic highlighting
Plug 'sbdchd/neoformat'                                           -- formatter
Plug('Shougo/deoplete.nvim', { ['do'] = ':UpdateRemotePlugins'})  -- autocomplete on steroids

Plug '~/src/vimminent'
Plug '~/src/pdocs'

vim.call('plug#end')

vim.cmd [[
  syntax enable
  colorscheme gruvbox
]]

local set = vim.opt
local map = vim.api.nvim_set_keymap

set.modeline = false
set.background = 'dark'
set.autoindent = true
set.backspace = 'indent,eol,start'
set.complete:remove('i')
set.smarttab = true
set.incsearch = true
set.autoread = true
set.encoding = 'utf-8'
set.compatible = false
set.gdefault = true
set.showcmd = true
set.scrolloff = 5

set.backup = false
set.writebackup = false
set.swapfile = false
set.undofile = false

set.timeoutlen = 1000
set.ttimeoutlen = 0

vim.g.mapleader = ','
vim.g.maplocalleader = ','

local map = vim.api.nvim_set_keymap

map('', ';', ':', {})  -- no shift for cmd mode
map('i', 'jj', '<Esc>', {})  -- no shift for cmd mode
map('', 'gp', '`[v`]', {noremap = true})  -- select last pasted lines
map('', '//', ':nohlsearch<enter>', {})

-- tab navigation
-- caveat: t is a default mapping for 'until'
map('', 'tt', ':tab split<enter>', {})
map('', 'tT', '<c-w>T', {})
map('', 'tc', ':tabclose<enter>', {})
map('', 'tp', ':tabprevious<enter>', {})
map('', 'tn', ':tabnext<enter>', {})
map('', 'to', ':tabonly<enter>', {})

-- ---------------------------------------------------------------------------
-- autosave and -read
set.autoread =  true
set.updatetime = 500

vim.cmd [[
  augroup autosave
      autocmd!
      autocmd InsertLeave,TextChanged * silent! w
      autocmd CursorHold,CursorHoldI * silent! update
      autocmd FocusLost * silent! wa
      autocmd FocusGained * checktime
  augroup END
]]

-- ---------------------------------------------------------------------------
-- Settings for Easymotion

vim.g['EasyMotion_do_mapping'] = 0
map('n', 's', '<Plug>(easymotion-overwin-f)', {})
map('n', 'S', '<Plug>(easymotion-overwin-f2)', {})


-- ---------------------------------------------------------------------------
-- Settings for nerdcommenter

vim.g['NERDDefaultAlign'] = 'left'

-- ---------------------------------------------------------------------------
-- Settings for semshi

vim.g['semshi#simplify_markup'] = 1

-- ---------------------------------------------------------------------------
-- Fugitive / Git

map('', '<leader>gd',  ':Gdiff<cr>', {noremap = true})
map('', '<leader>gs',  ':Gstatus<cr><c-w>T', {noremap = true})
map('', '<leader>gw',  ':Gwrite<cr>', {noremap = true})
map('', '<leader>ga',  ':Gadd<cr>', {noremap = true})
map('', '<leader>gb',  ':Gblame<cr>', {noremap = true})
map('', '<leader>gco', ':Gcheckout<cr>', {noremap = true})
map('', '<leader>gci', ':Gcommit<cr>', {noremap = true})
map('', '<leader>gm',  ':Gmove<cr>', {noremap = true})
map('', '<leader>gr',  ':Gremove<cr>', {noremap = true})
map('', '<leader>gl',  ':Glog<cr>', {noremap = true})

vim.cmd [[
  augroup ft_fugitive
      au!

      au BufNewFile,BufRead .git/index setlocal nolist
  augroup END
]]

-- "Hub"
--nnoremap <leader>H :Gbrowse<cr>
--vnoremap <leader>H :Gbrowse<cr>

-- Extradite
map('', '<leader>gh', ':Extradite!<cr>', {noremap = true})

-- ---------------------------------------------------------------------------
-- vimminent

map('', '<leader>,',  ':call NavProjectFiles()<cr>', {})
map('', '<leader>.',  ':call NavProjectSymbols()<cr>', {})
map('', '<leader>..', ':call NavFileSymbols()<cr>', {})
map('', '<leader>d',  ':call NavCwordProjectSymbols()<cr>', {})
map('', '<leader>b',  ':call NavBuffers()<cr>', {})

map('', '<leader>F', ':call NavAllFiles()<cr>', {})
map('', '<leader>L', ':call NavAllLines()<cr>', {})
map('', '<leader>l', ':call NavProjectLines()<cr>', {})

map('', '<leader>D',  ':call NavCwordDocs()<cr>', {})
map('', '<leader>DD', ':call NavDocs()<cr>', {})
