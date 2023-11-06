local mod = {}

function mod.setup()
    local hop = require('hop')
    hop.setup({
        multi_windows = true, -- this means more targets, potentially longer sequence to reach
        -- multi_windows is broken https://github.com/phaazon/hop.nvim/issues/244
        -- because they use signs (arguably better than easymotion)
        -- but signs are attached to a buffer, not to a window
        -- commented there with a possible solution
        char2_fallback_key = '<enter>',
        jump_on_sole_occurrence = false,
        -- based on https://colemakmods.github.io/mod-dh/model.html
        keys = 'ntseriufhdywoa',
    })

    -- vim.keymap.set('n', 'r', hop.hint_char1, { desc = 'hop 1char' })
    -- vim.keymap.set('n', 'R', hop.hint_char2, { desc = 'hop 2char' })
    vim.keymap.set('n', ' ', hop.hint_char2, { desc = 'hop 2char' })
end

return mod
