local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'Pocco81/auto-save.nvim'
end

function mod.setup()
    require 'auto-save'.setup(
        {
            enabled = true,
            events = { "InsertLeave", "TextChanged" },
            debounce_delay = 500,
        }
    )
end

return mod
