local map = vim.api.nvim_set_keymap

require'hop'.setup()
map('n', 's', ':HopChar1<cr>', {})
map('n', 'S', ':HopChar2<cr>', {})

require'Comment'.setup()

require'autosave'.setup(
  {
    enabled = true,
    events = {"InsertLeave", "TextChanged"},
    debounce_delay = 500,
  }
)

-- ---------------------------------------------------------------------------
-- Fugitive / Git

map('', '<leader>gd',  ':Git diff<cr>', {noremap = true})
map('', '<leader>gs',  ':Git<cr><c-w>T', {noremap = true})
map('', '<leader>gw',  ':Gwrite<cr>', {noremap = true})
map('', '<leader>ga',  ':Gadd<cr>', {noremap = true})
map('', '<leader>gb',  ':Gblame<cr>', {noremap = true})
map('', '<leader>gco', ':Git checkout<cr>', {noremap = true})
map('', '<leader>gci', ':Git commit<cr>', {noremap = true})
map('', '<leader>gm',  ':Gmove<cr>', {noremap = true})
map('', '<leader>gr',  ':Gremove<cr>', {noremap = true})
map('', '<leader>gl',  ':Gclog<cr>', {noremap = true})

vim.cmd [[
  augroup ft_fugitive
      au!

      au BufNewFile,BufRead .git/index setlocal nolist
  augroup END
]]

-- ---------------------------------------------------------------------------
-- telescope
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
})
require('telescope').load_extension('coc')

map('', '<leader>,',  ':Telescope git_files<cr>', {})
map('', '<leader>.',  ':Telescope coc workspace_symbols<cr>', {})
map('', '<leader>..',  ':Telescope coc document_symbols<cr>', {})


map('', '<leader>d',  ':Telescope coc definitions<cr>', {})
map('', '<leader>D',  ':Telescope coc diagnostics<cr>', {})


require("nvim-treesitter.configs").setup({
  sync_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})

-- ---------------------------------------------------------------------------
-- Settings for neoformat

-- neoformat (new fixed by dkuettel)
--nnoremap == :Black<cr> " Plugin disabled currently, see above
-- neoformat is buggy:
-- - multiple formatters in a sequence can cut off the file at the end
--   see https://github.com/sbdchd/neoformat/pull/235 and https://github.com/sbdchd/neoformat/issues/256
-- - the working directory is _changed_ to the file being formatted, that makes it hard to discover configurations or venvs
--   see https://github.com/sbdchd/neoformat/issues/47 (merged unfortunately)
-- as a workaround:
-- - use a single executable that chains isort and black
-- - set a env variable when starting vim for the formatter to use to discover a venv or settings
-- TODO I dont get anymore a message about changes needed
vim.g['neoformat_enabled_python'] = {'isort_and_black'}
vim.g['neoformat_only_msg_on_error'] = 0
--let g:neoformat_try_formatprg = 1
vim.cmd [[
  let $vim_project_folder = $PWD
  let g:neoformat_python_isort_and_black = { 'exe': 'isort_and_black', 'args': [], 'stdin': 1 }
]]

vim.g['neoformat_basic_format_align'] = 0
vim.g['neoformat_basic_format_retab'] = 1
vim.g['neoformat_basic_format_trim'] = 1

map('', '==', ':Neoformat<cr>', {})

-- ---------------------------------------------------------------------------
-- Settings for deoplete

--vim.cmd [[
--  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
--]]

