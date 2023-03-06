local mod = {}

function mod.setup()
    local map = vim.api.nvim_set_keymap

    require('hop').setup()
    map('n', 's', ':HopChar1<cr>', {})
    map('n', 'S', ':HopChar2<cr>', {})
end

return mod
