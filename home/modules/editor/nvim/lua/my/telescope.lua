local mod = {}

function mod.setup()
    local map = vim.keymap.set
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local bi = require('telescope.builtin')

    local defaults = require('telescope.themes').get_ivy({ layout_config = { height = 0.4 } })
    defaults.scroll_strategy = 'limit'
    defaults.mappings = {
        i = {
            ['<c-j>'] = actions.move_selection_next,
            ['<c-k>'] = actions.move_selection_previous,
            ['<enter>'] = actions.select_default,
            ['<c-v>'] = actions.select_vertical,
            ['<c-s>'] = actions.select_horizontal,
            ['<c-t>'] = actions.select_tab,
            ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<s-tab>'] = actions.toggle_all,
        },
        n = {
            ['q'] = actions.close,
            ['j'] = 'move_selection_next',
            ['k'] = 'move_selection_previous',
            ['<enter>'] = actions.select_default,
            ['<c-v>'] = actions.select_vertical,
            ['<c-s>'] = actions.select_horizontal,
            ['<c-t>'] = actions.select_tab,
            ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<s-tab>'] = actions.toggle_all,
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

    map('n', ',f', bi.find_files, { desc = 'find files' })
    map('', '<leader>,', ':Telescope git_files<cr>', { desc = 'find git files' })
    map('n', '<leader>..', bi.lsp_document_symbols, { desc = 'document symbols' })
    map('n', '<leader>.', bi.lsp_dynamic_workspace_symbols, { desc = 'workspace symbols' })

    map('n', ',gr', bi.live_grep, { desc = 'live grep' })
    map('n', ',b', bi.buffers, { desc = 'buffers' })
    map('n', ',h', bi.help_tags, { desc = 'help tags' })
    map('n', ',m', function()
        bi.man_pages({ sections = { 'ALL' } })
    end, { desc = 'man pages' })
    map('n', ',cc', bi.commands, { desc = 'vim commands' })

    map('n', ',]d', function()
        bi.diagnostics({ bufnr = 0 })
    end, { desc = 'lsp diagnostic buffer messages' })
    map('n', ',]D', function()
        bi.diagnostics({ bufnr = nil })
    end, { desc = 'lsp diagnostic all messages' })
end

return mod
