local mod = {}

function mod.setup()
    vim.g['fugitive_no_maps'] = 1

    vim.keymap.set('n', ',gs', ':tab Git<enter>')

    vim.api.nvim_create_autocmd('User', {
        pattern = { 'FugitiveIndex', 'FugitiveObject' },
        callback = function()
            local map = vim.keymap.set
            map('n', 'q', '<c-w>c', { buffer = true, nowait = true }) -- close
            map('n', 't', '<Plug>fugitive:-', { buffer = true, nowait = true }) -- stage and unstage
            map('n', 'e', '<Plug>fugitive:)', { buffer = true, nowait = true }) -- next file, hunk, or revision
            map('n', 'u', '<Plug>fugitive:(', { buffer = true, nowait = true }) -- previous file, hunk, or revision
            map('n', 'n', '<Plug>fugitive:<', { buffer = true, nowait = true }) -- remove inline diff
            map('n', 'i', '<Plug>fugitive:>', { buffer = true, nowait = true }) -- insert inline diff
        end,
    })

    -- local map = vim.api.nvim_set_keymap
    -- map('', '<leader>gd', ':Git diff<cr>', { noremap = true })
    -- map('', '<leader>gs', ':Git<cr><c-w>T', { noremap = true })
    -- map('', '<leader>gb', ':Git blame<cr>', { noremap = true })
    -- map('', '<leader>gc', ':Git commit<cr>', { noremap = true })
    -- map('', '<leader>gl', ':Gclog<cr>', { noremap = true })
    --
    -- vim.cmd([[
    --   augroup ft_fugitive
    --       au!
    --
    --       au BufNewFile,BufRead .git/index setlocal nolist
    --   augroup END
    -- ]])

    require('gitsigns').setup()
end

return mod
