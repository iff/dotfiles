"curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'              " colors for vim
Plug 'kien/ctrlp.vim'               " open anything
Plug 'sjl/gundo.vim'                " undo history tree
Plug 'tpope/vim-airline'            " bottom bar
Plug 'tpope/vim-sleuth'             " heuristically set buffer options
Plug 'tpope/vim-surround'           " surround with brackets, quotes, ...
Plug 'easymotion/vim-easymotion'    " the only movement command you will ever use
Plug 'davidhalter/jedi-vim'         " jump to definition etc..
Plug 'scrooloose/nerdcommenter'
"Plug 'vim-syntastic/syntastic'

" Git plugins
Plug 'airblade/vim-gitgutter'       " show unstaged edits
Plug 'tpope/vim-fugitive'           " many git helpers
Plug 'tpope/vim-rhubarb'            " goto github page
Plug 'int3/vim-extradite'           " git commit browser

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}      " python syn-tactic highlighting
Plug 'sbdchd/neoformat'                                     " formatter
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocomplete on steroids

call plug#end()

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
" interesting events:
" InsertLeave, TextChanged, CursorHold
" TextChangedI, CursorHoldI
" FocusGained, FocusLost
" (needs events configured coming from the terminal or tmux, check if that works)
set autoread
set updatetime=500
augroup autosave
    autocmd!
    autocmd InsertLeave,TextChanged * silent! w
    autocmd CursorHold,CursorHoldI * silent! update
    autocmd FocusLost * silent! wa
    autocmd FocusGained * checktime
augroup END
" problems:
" should not run :w when buffer has no file
" silent! surpressed that error messages
" but would be nicer not to try at all
" CursorHoldI doesn't seem to trigger update currently


" ---------------------------------------------------------------------------
" Settings for semshi

let g:semshi#simplify_markup = 1


" ---------------------------------------------------------------------------
" Settings for neoformat

let g:neoformat_enabled_python = ['black']
let g:neoformat_try_formatprg = 1

let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

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
" Settings for jedi

let g:jedi#use_splits_not_buffers = "right"
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"

let g:jedi#goto_command = ''
nmap <leader>dd :call jedi#goto()<cr>zt " not sure if that is
nmap <leader>dt :tab split<cr>,dd
nmap <leader>ds <c-w>s,dd
nmap <leader>dv <c-w>v,dd
nmap <leader>dp <c-w>} " alternative for preview on tag


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
" Ctrl-P

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
let g:ctrlp_match_current_file = 1 " match files even when it's the current file
let g:ctrlp_map = '<leader>,'
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>t :CtrlPBufTag<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

