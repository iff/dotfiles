"curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'              " colors for vim
Plug 'kien/ctrlp.vim'               " open anything
Plug 'sjl/gundo.vim'                " undo history tree
Plug 'tpope/vim-airline'            " bottom bar
Plug 'tpope/vim-sleuth'             " heuristically set buffer options
Plug 'tpope/vim-surround'           " surround with brackets, quotes, ...
Plug 'easymotion/vim-easymotion'    " the only movemement command you will ever use
Plug 'davidhalter/jedi-vim'         " jump to definition etc..
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

imap jj <Esc>

" ---------------------------------------------------------------------------
" Settings for semshi

let g:semshi#simplify_markup = 1


" ---------------------------------------------------------------------------
" Settings for neoformat

let g:neoformat_python_black = {
    \ 'exe': 'python3 -m black',
    \ 'args': [],
    \ 'replace': 1,
    \ 'stdin': 1,
    \ 'env': [],
    \ 'valid_exit_codes': [0, 23],
    \ 'no_append': 1,
    \ }

let g:neoformat_enable_python = ['black']
let g:neoformat_basic_format_trim = 1
"augroup fmt
  "autocmd!
  "autocmd BufWritePre * undojoin | Neoformat
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
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction

" ---------------------------------------------------------------------------
" Settings for Easymotion

nmap s <Plug>(easymotion-overwin-f)
map <Leader>' <Plug>(easymotion-prefix)


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

