local leader_map = function()
  vim.g.mapleader = ','
  vim.g.maplocalleader = ','
end

local disable_distribution_plugins = function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
end

local options = function()
  local set = vim.opt

  set.termguicolors = true
  set.modeline = false
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

  set.inccommand='nosplit'
end

local load = function()
  require('plugins')

  disable_distribution_plugins()
  leader_map()

  require('theme').setup()
  
  options()

  require('keymap')

  require('Comment').setup()
  require('my/hop').setup()
  require('my/autosave').setup()
  require('my/git').setup()

  require('my/telescope').setup()
  require('my/coc').setup()
  require('my/treesitter').setup()
  require('my/neoformat').setup()
end

load()

