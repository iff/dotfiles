"curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')

" colors for vim
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'
" Plug 'rktjmp/lush.nvim', { 'branch': 'main' }
" Plug 'npxbr/gruvbox.nvim', { 'branch': 'main' }

Plug 'sjl/gundo.vim'                " undo history tree
Plug 'vim-airline/vim-airline'      " bottom bar
Plug 'tpope/vim-sleuth'             " heuristically set buffer options
Plug 'tpope/vim-surround'           " surround with brackets, quotes, ...
"Plug 'easymotion/vim-easymotion'    " the only movement command you will ever use
Plug 'scrooloose/nerdcommenter'
Plug 'phaazon/hop.nvim'

" Git plugins
Plug 'airblade/vim-gitgutter'       " show unstaged edits
Plug 'tpope/vim-fugitive'           " many git helpers
Plug 'int3/vim-extradite'           " git commit browser

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}      " python syn-tactic highlighting
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'sbdchd/neoformat'                                     " formatter
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocomplete on steroids

Plug '~/src/vimminent'
Plug '~/src/pdocs'

call plug#end()

set nomodeline
syntax enable
set background=dark

"if (has("termguicolors"))
" set termguicolors
"endif

colorscheme gruvbox
" let g:gruvbox_contrast = 'medium'
" colorscheme OceanicNext

let mapleader = ","
let maplocalleader = ','

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set incsearch
set autoread
set encoding=utf-8
set nocompatible
set gdefault                  " automatically use /g with search & replace
set showcmd
set scrolloff=5

set nobackup
set nowritebackup
set noswapfile
set noundofile

set timeoutlen=1000 ttimeoutlen=0

imap jj <Esc>
map ; :
nnoremap gp `[v`]                     " select last pasted lines
map // :nohlsearch<enter>

" tab navigation
" caveat: t is a default mapping for 'until'
map tt :tab split<enter>
map tT <c-w>T
map tc :tabclose<enter>
map tp :tabprevious<enter>
map tn :tabnext<enter>
map to :tabonly<enter>


" ---------------------------------------------------------------------------
" autosave and -read
set autoread
set updatetime=500
augroup autosave
    autocmd!
    autocmd InsertLeave,TextChanged * silent! w
    autocmd CursorHold,CursorHoldI * silent! update
    autocmd FocusLost * silent! wa
    autocmd FocusGained * checktime
augroup END


" ---------------------------------------------------------------------------
" Settings for nerdcommenter

let g:NERDDefaultAlign = 'left'


" ---------------------------------------------------------------------------
" Settings for semshi

let g:semshi#simplify_markup = 1


" ---------------------------------------------------------------------------
" Settings for neoformat

"let g:neoformat_enabled_python = ['isort', 'black']
"let g:neoformat_run_all_formatters = 1
"let g:neoformat_try_formatprg = 1

"let g:neoformat_python_black = {
"            \ 'exe': 'black',
"            \ 'args': ['--quiet', '--target-version=py38', '-'],
"            \ 'stdin': 1,
"            \ }
"let g:neoformat_python_isort = {
"            \ 'exe': 'isort',
"            \ 'args': ['--profile=black', '--combine-as', '-'],
"            \ 'stdin': 1,
"            \ }

"let g:neoformat_basic_format_align = 0
"let g:neoformat_basic_format_retab = 1
"let g:neoformat_basic_format_trim = 1

""map <leader>f :Neoformat<cr>
"map == :Neoformat<cr>

"augroup fmt
"  autocmd!
"  "autocmd BufWritePre * undojoin | Neoformat
"  autocmd BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
"augroup END

""" neoformat (new fixed by dkuettel)
"nnoremap == :Black<cr> " Plugin disabled currently, see above
" neoformat is buggy:
" - multiple formatters in a sequence can cut off the file at the end
"   see https://github.com/sbdchd/neoformat/pull/235 and https://github.com/sbdchd/neoformat/issues/256
" - the working directory is _changed_ to the file being formatted, that makes it hard to discover configurations or venvs
"   see https://github.com/sbdchd/neoformat/issues/47 (merged unfortunately)
" as a workaround:
" - use a single executable that chains isort and black
" - set a env variable when starting vim for the formatter to use to discover a venv or settings
" TODO I dont get anymore a message about changes needed
let g:neoformat_enabled_python = ['isort_and_black']
let g:neoformat_only_msg_on_error = 0
"let g:neoformat_try_formatprg = 1
let $vim_project_folder = $PWD
let g:neoformat_python_isort_and_black = {
        \ 'exe': 'isort_and_black',
        \ 'args': [],
        \ 'stdin': 1,
    \ }
let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
map == :Neoformat<cr>

" ---------------------------------------------------------------------------
" Settings for deoplete

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
    \ 'auto_complete_delay': 100,
    \ })

call deoplete#custom#option('keyword_patterns', {
   \ 'denite-filter': '',
   \})

call deoplete#custom#source('_',
    \ 'matchers', ['matcher_fuzzy', 'matcher_length'])

inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" inoremap <silent><expr> <TAB>
"    \ pumvisible() ? "\<C-n>" :
"    \ <SID>check_back_space() ? "\<TAB>" :
"    \ deoplete#mappings#manual_complete()
"    function! s:check_back_space() abort "{{{
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"    endfunction"}}}

" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function() abort
"     return deoplete#close_popup() . "\<CR>"
" endfunction

" ---------------------------------------------------------------------------
" Settings for Easymotion

"let g:EasyMotion_do_mapping = 0
"nmap s <Plug>(easymotion-overwin-f)
"nmap S <Plug>(easymotion-overwin-f2)

map s :HopChar1<cr>
map S :HopChar2<cr>

" ---------------------------------------------------------------------------
" Fugitive / Git

nnoremap <leader>gd :Git diff<cr>
nnoremap <leader>gs :Git<cr><c-w>T
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Git checkout<cr>
nnoremap <leader>gci :Git commit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gl :Git log<cr>

augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
augroup END

" "Hub"
nnoremap <leader>H :Gbrowse<cr>
vnoremap <leader>H :Gbrowse<cr>

" Extradite
nnoremap <leader>gh :Extradite!<cr>


" ---------------------------------------------------------------------------
" vimminent

map <leader>, :call NavProjectFiles()<cr>
map <leader>. :call NavProjectSymbols()<cr>
map <leader>.. :call NavFileSymbols()<cr>
map <leader>d :call NavCwordProjectSymbols()<cr>
map <leader>b :call NavBuffers()<cr>

map <leader>F :call NavAllFiles()<cr>
map <leader>L :call NavAllLines()<cr>
map <leader>l :call NavProjectLines()<cr>

map <leader>D :call NavCwordDocs()<cr>
map <leader>DD :call NavDocs()<cr>


" ---------------------------------------------------------------------------
" shenshi
" todo maybe exclude local, speed? too many colors?
let g:semshi#excluded_hl_groups = []
" todo potentially slow?
let g:semshi#always_update_all_highlights = v:true
" problem: if semshi would use the default keyword for its highlights, we didn't have to workaround with autocmds
"                                                   cterm-colors
"      NR-16   NR-8    COLOR NAME
"      0       0       Black
"      1       4       DarkBlue
"      2       2       DarkGreen
"      3       6       DarkCyan
"      4       1       DarkRed
"      5       5       DarkMagenta
"      6       3       Brown, DarkYellow
"      7       7       LightGray, LightGrey, Gray, Grey
"      8       0*      DarkGray, DarkGrey
"      9       4*      Blue, LightBlue
"      10      2*      Green, LightGreen
"      11      6*      Cyan, LightCyan
"      12      1*      Red, LightRed
"      13      5*      Magenta, LightMagenta
"      14      3*      Yellow, LightYellow
"      15      7*      White
"
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

" ---------------------------------------------------------------------------
" nvim-tree-splitter
"lua <<EOF
"require'nvim-treesitter.configs'.setup {
"  highlight = { enable = true },
"  incremental_selection = { enable = true },
"  textobjects = { enable = true },
"}
"EOF
