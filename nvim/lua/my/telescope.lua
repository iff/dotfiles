local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'fannheyward/telescope-coc.nvim'
    Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make'})
end

function mod.setup()
    local map = vim.api.nvim_set_keymap
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local defaults = require("telescope.themes").get_dropdown()
    defaults.layout_config.width = function(_, max_columns, _)
        return math.min(max_columns, 120)
    end
    defaults.mappings = {
        i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
            ["q"] = actions.close,
        },
    }
    defaults.path_display = { "truncate" }

    telescope.setup({
        defaults = defaults,
        extensions = {
            -- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
            fzf = {},
        },
    })
    telescope.load_extension('fzf')
    telescope.load_extension('coc')

    map('', '<leader>,',  ':Telescope git_files<cr>', {})
    map('', '<leader>.',  ':Telescope coc workspace_symbols<cr>', {})
    map('', '<leader>..',  ':Telescope coc document_symbols<cr>', {})


    map('', '<leader>d',  ':Telescope coc definitions<cr>', {})
    map('', '<leader>D',  ':Telescope coc diagnostics<cr>', {})
end

return mod
