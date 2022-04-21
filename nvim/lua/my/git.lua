local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'tpope/vim-fugitive'
    Plug 'lewis6991/gitsigns.nvim'
end

function mod.setup()
    local map = vim.api.nvim_set_keymap
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

    require("gitsigns").setup()
end

return mod
