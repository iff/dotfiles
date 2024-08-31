local mod = {}

function mod.setup()
    local hop = require('hop')
    hop.setup({
        multi_windows = true, -- this means more targets, potentially longer sequence to reach
        char2_fallback_key = '<enter>',
        jump_on_sole_occurrence = true,
        -- based on https://colemakmods.github.io/mod-dh/model.html
        keys = 'ntseriufhdywoa',
    })

    vim.keymap.set({'n', 'v'}, ' ', hop.hint_char2, { desc = 'hop 2char' })
    vim.keymap.set('i', '<F11> ', function()
        hop.hint_char1({
            direction = require('hop.hint').HintDirection.AFTER_CURSOR,
            current_line_only = true,
        })
    end, { desc = 'insert jump on line' })
end

return mod
