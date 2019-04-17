"curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-airline'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'davidhalter/jedi-vim'
"Plug 'vim-syntastic/syntastic'

" Git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'int3/vim-extradite'

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'sbdchd/neoformat'

call plug#end()


syntax on
set background=dark
colorscheme gruvbox

let mapleader = ","
let maplocalleader=','        " all my macros start with ,

imap jj <Esc>


" ---------------------------------------------------------------------------
" Settings for semshi
"
let g:semshi_simplify_markup = 1


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
let g:ctrlp_match_current_file = 1 " match files even when it's the current file
let g:ctrlp_map = '<leader>,'
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>t :CtrlPBufTag<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
