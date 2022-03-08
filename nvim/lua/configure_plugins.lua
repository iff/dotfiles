local map = vim.api.nvim_set_keymap

-- ---------------------------------------------------------------------------
-- Settings for Easymotion

vim.g['EasyMotion_do_mapping'] = 0
map('n', 's', '<Plug>(easymotion-overwin-f)', {})
map('n', 'S', '<Plug>(easymotion-overwin-f2)', {})

--map('', 's', ':HopChar1', {})
--map('', 'S', ':HopChar2', {})


-- ---------------------------------------------------------------------------
-- Settings for nerdcommenter

vim.g['NERDDefaultAlign'] = 'left'

-- ---------------------------------------------------------------------------
-- Settings for semshi

vim.g['semshi#simplify_markup'] = 1

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
map('', '<leader>gl',  ':Git log<cr>', {noremap = true})

vim.cmd [[
  augroup ft_fugitive
      au!

      au BufNewFile,BufRead .git/index setlocal nolist
  augroup END
]]

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

vim.g['pdocs_default_mappings'] = 1
-- map('', '<leader>D',  ':call NavCwordDocs()<cr>', {})
-- map('', '<leader>DD', ':call NavDocs()<cr>', {})


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

vim.g['deoplete#enable_at_startup'] = 1

vim.cmd [[
call deoplete#custom#option({ 'auto_complete_delay': 100, })

call deoplete#custom#option('keyword_patterns', { 'denite-filter': '', })

call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy', 'matcher_length'])

inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
]]


-- ---------------------------------------------------------------------------
-- shenshi
-- todo maybe exclude local, speed? too many colors?
vim.g['semshi#excluded_hl_groups'] = {}
vim.g['semshi#always_update_all_highlights'] = true
-- problem: if semshi would use the default keyword for its highlights, we didn't have to workaround with autocmds
--                                                   cterm-colors
--      NR-16   NR-8    COLOR NAME
--      0       0       Black
--      1       4       DarkBlue
--      2       2       DarkGreen
--      3       6       DarkCyan
--      4       1       DarkRed
--      5       5       DarkMagenta
--      6       3       Brown, DarkYellow
--      7       7       LightGray, LightGrey, Gray, Grey
--      8       0*      DarkGray, DarkGrey
--      9       4*      Blue, LightBlue
--      10      2*      Green, LightGreen
--      11      6*      Cyan, LightCyan
--      12      1*      Red, LightRed
--      13      5*      Magenta, LightMagenta
--      14      3*      Yellow, LightYellow
--      15      7*      White

vim.cmd [[
  function! SemshiCustomColors()
      " vim python highlights
      hi pythonComment ctermfg=8 cterm=italic
      "hi pythonStatement ctermfg=2 cterm=italic
      hi pythonFunction ctermfg=4
      "hi pythonInclude ctermfg=10 cterm=italic
      hi pythonString ctermfg=2
      hi pythonQuotes ctermfg=2
      "hi pythonOperator ctermfg=2 cterm=italic
      "hi pythonKeyword ctermfg=2 cterm=italic
      "hi pythonConditional ctermfg=2 cterm=italic
      "hi pythonDecorator ctermfg=4
      "hi pythonDecoratorName ctermfg=10 cterm=italic
      " semshi highlights
      " todo missing different colors for type hints
      " todo missing different colors for kw name vs kw value
      hi semshiLocal ctermfg=7 cterm=none
      "hi semshiGlobal ctermfg=4 cterm=none
      hi semshiImported ctermfg=3 cterm=none
      hi semshiParameter ctermfg=4 cterm=underline
      hi semshiParameterUnused ctermfg=4 cterm=strikethrough
      hi semshiAttribute ctermfg=12 cterm=none
      "hi semshiFree ctermfg=15 cterm=bold
      hi semshiBuiltin ctermfg=7 cterm=italic
      hi semshiSelf ctermfg=8 cterm=italic
      hi semshiUnresolved ctermfg=10 cterm=strikethrough
      hi semshiSelected ctermfg=14 ctermbg=0 cterm=underline
      hi semshiErrorSign ctermfg=1 cterm=none
      sign define semshiError text=E> texthl=semshiErrorSign
      hi semshiErrorChar ctermfg=10 cterm=strikethrough
  endfunction
  autocmd FileType python call SemshiCustomColors()
]]
