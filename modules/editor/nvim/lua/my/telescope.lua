local mod = {}

function mod.setup()
    local map = vim.api.nvim_set_keymap
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local bi = require('telescope.builtin')

    local defaults = require('telescope.themes').get_dropdown()
    defaults.layout_config.width = function(_, max_columns, _)
        return math.min(max_columns, 120)
    end
    defaults.mappings = {
        i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
        },
        n = {
            ['q'] = actions.close,
        },
    }
    defaults.path_display = { 'truncate' }

    telescope.setup({
        defaults = defaults,
        extensions = {
            -- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
            fzf = {},
        },
    })
    telescope.load_extension('fzf')

    map('', '<leader>,', ':Telescope git_files<cr>', {})

    vim.keymap.set('n', '<leader>..', bi.lsp_document_symbols)
    vim.keymap.set('n', '<leader>.', bi.lsp_dynamic_workspace_symbols)
end

return mod
