"curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'              " colors for vim
Plug 'sjl/gundo.vim'                " undo history tree
Plug 'vim-airline/vim-airline'      " bottom bar
Plug 'tpope/vim-sleuth'             " heuristically set buffer options
Plug 'tpope/vim-surround'           " surround with brackets, quotes, ...
Plug 'easymotion/vim-easymotion'    " the only movement command you will ever use
Plug 'scrooloose/nerdcommenter'

" Git plugins
Plug 'airblade/vim-gitgutter'       " show unstaged edits
Plug 'tpope/vim-fugitive'           " many git helpers
Plug 'tpope/vim-rhubarb'            " goto github page
Plug 'int3/vim-extradite'           " git commit browser

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}      " python syn-tactic highlighting
Plug 'sbdchd/neoformat'                                     " formatter
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocomplete on steroids

Plug '~/src/vimminent'
Plug '~/src/pdocs'

" retired plugins:
" Plug 'kien/ctrlp.vim'               " open anything
" Plug 'davidhalter/jedi-vim'         " jump to definition etc..
" Plug 'vim-syntastic/syntastic'

call plug#end()

set nomodeline
syntax enable
set background=dark
colorscheme gruvbox

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

set nobackup
set nowritebackup
set noswapfile
set noundofile

set timeoutlen=1000 ttimeoutlen=0

imap jj <Esc>
map ; :
nnoremap gp `[v`]                     " select last pasted lines


" ---------------------------------------------------------------------------
" Settings for nerdcommenter

let g:NERDDefaultAlign = 'left'


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

let g:neoformat_enabled_python = ['black']
let g:neoformat_try_formatprg = 1

let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'args': ['-', '--quiet', '--target-version=py36'],
            \ 'stdin': 1,
            \ }

let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

map <leader>f :Neoformat<cr>

"augroup fmt
"  autocmd!
"  "autocmd BufWritePre * undojoin | Neoformat
"  autocmd BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
"augroup END

" ---------------------------------------------------------------------------
" Settings for deoplete

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
    \ 'auto_complete_delay': 100,
    \ 'auto_complete': v:false,
\ })

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
    function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}

" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function() abort
"     return deoplete#close_popup() . "\<CR>"
" endfunction

" ---------------------------------------------------------------------------
" Settings for Easymotion

let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f)
nmap S <Plug>(easymotion-overwin-f2)


" ---------------------------------------------------------------------------
" Fugitive / Git

nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr>
"nnoremap <leader>gl :Shell git l19<cr>:wincmd \|<cr>

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
map <leader>d :call NavCwordProjectSymbols()<cr>
map <leader>b :call NavBuffers()<cr>

map <leader>F :call NavAllFiles()<cr>
map <leader>L :call NavAllLines()<cr>
map <leader>l :call NavProjectLines()<cr>

