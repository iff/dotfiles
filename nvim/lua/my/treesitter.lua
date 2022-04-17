local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
end

function mod.setup()
end

return mod
