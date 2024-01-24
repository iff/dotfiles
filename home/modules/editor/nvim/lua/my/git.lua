local mod = {}

function mod.setup()
    vim.g['fugitive_no_maps'] = 1

    vim.keymap.set('n', 'aa', ':tab Git<enter>')
    -- vim.keymap.set('n', ',gd', ':Git diff<cr>')
    -- vim.keymap.set('n', ',gl', ':Gclog<cr>')

    vim.api.nvim_create_autocmd('User', {
        pattern = { 'FugitiveIndex', 'FugitiveObject' },
        callback = function()
            local function map(m, a, b, desc)
                vim.keymap.set(m, a, b, { buffer = true, nowait = true, desc = desc })
            end
            map('n', 'ft,', '<cmd>tabclose<enter>', 'close tab')
            map('n', 'st,', '<c-w>c', 'close window')
            map('n', 'qq', '<Plug>fugitive:U', 'unstage everything')
            map({ 'n', 'v' }, 't', '<Plug>fugitive:-', 'stage or unstage')
            map({ 'n', 'v' }, 'v', 'V', 'line visual mode')
            map('v', 'u', 'k', 'move up in visual mode')
            map('v', 'e', 'j', 'move down in visual mode')
            map('n', 'e', '<Plug>fugitive:)', 'next file, hunk, or revision')
            map('n', 'u', '<Plug>fugitive:(', 'previous file, hunk, or revision')
            map('n', 'n', '<Plug>fugitive:<', 'remove inline diff')
            map('n', 'i', '<Plug>fugitive:>', 'insert inline diff')
            map('n', 'd', '<Plug>fugitive:O<cmd>Gvdiff<enter>', 'diff in tab')
            map('n', 'g', '<Plug>fugitive:O', 'open file')

            -- map('n', 't', '<Plug>fugitive:-', { buffer = true, nowait = true }) -- stage and unstage
        end,
    })

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
