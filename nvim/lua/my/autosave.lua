local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'Pocco81/AutoSave.nvim'
end

function mod.setup()
    require 'autosave'.setup(
        {
            enabled = true,
            events = { "InsertLeave", "TextChanged" },
            debounce_delay = 500,
        }
    )
end

return mod
