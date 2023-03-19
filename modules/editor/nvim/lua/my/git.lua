local mod = {}

function mod.setup()
    local map = vim.api.nvim_set_keymap
    map('', '<leader>gd', ':Git diff<cr>', { noremap = true })
    map('', '<leader>gs', ':Git<cr><c-w>T', { noremap = true })
    map('', '<leader>gb', ':Git blame<cr>', { noremap = true })
    map('', '<leader>gc', ':Git commit<cr>', { noremap = true })
    map('', '<leader>gl', ':Gclog<cr>', { noremap = true })

    vim.cmd([[
      augroup ft_fugitive
          au!
    
          au BufNewFile,BufRead .git/index setlocal nolist
      augroup END
    ]])

    require('gitsigns').setup()
end

return mod
