local mod = {}

function mod.setup()
    local map = vim.keymap.set
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local bi = require('telescope.builtin')

    require('telescope.pickers.layout_strategies').laforge = function(self, max_columns, max_lines, layout_config)
        -- local resolve = require("telescope.config.resolve")
        -- local p_window = require("telescope.pickers.window")
        -- local initial_options = p_window.get_initial_window_options(self)
        -- local results = initial_options.results
        -- local prompt = initial_options.prompt
        -- local preview = initial_options.preview
        local half = vim.fn.round(max_lines / 2)
        local pad = 3
        return {
            preview = {
                border = true,
                borderchars = { '─', '│', '═', '│', '┌', '┐', '╛', '╘' },
                col = 2,
                enter = false,
                height = half - pad - 3,
                line = 2,
                width = max_columns - 2,
            },
            prompt = {
                border = true,
                borderchars = { '═', '│', '─', '│', '╒', '╕', '│', '│' },
                col = 2,
                enter = true,
                height = 1,
                line = half + pad + 2,
                title = self.prompt_title,
                width = max_columns - 2,
            },
            results = {
                border = { 0, 1, 1, 1 },
                borderchars = { '═', '│', '─', '│', '╒', '╕', '┘', '└' },
                col = 2,
                enter = false,
                height = max_lines - half - pad - 4,
                line = half + pad + 4,
                width = max_columns - 2,
            },
        }
    end

    -- local defaults = require('telescope.themes').get_ivy({ layout_config = { height = 0.4 } })
    local defaults = {
        -- TODO how to make the layout strat and the rest go together? many things are not independent, like sorting_strategy
        layout_strategy = 'laforge',
        sorting_strategy = 'ascending',
        prompt_prefix = '󰄾 ',
        entry_prefix = '   ',
        selection_caret = ' 󰧚 ',
    }
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
            ['<c-f>'] = function(prompt_bufnr)
                telescope.extensions.hop._hop(prompt_bufnr, { callback = actions.select_default })
            end,
        },
        n = {
            ['q'] = actions.close,
            ['y'] = 'move_selection_next',
            ['l'] = 'move_selection_previous',
            ['<enter>'] = actions.select_default,
            ['n'] = actions.select_vertical,
            ['u'] = actions.select_horizontal,
            ['t'] = actions.select_tab,
            ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<s-tab>'] = actions.toggle_all,
        },
    }
    defaults.path_display = { 'truncate' }

    telescope.setup({
        defaults = defaults,
        extensions = {
            fzf = {},
            hop = {},
            ['ui-select'] = {},
        },
    })
    telescope.load_extension('fzf')
    telescope.load_extension('hop')
    telescope.load_extension('ui-select')

    map('', 'gg', ':Telescope git_files<cr>', { desc = 'find git files' })
    map('n', 'ge', bi.lsp_document_symbols, { desc = 'document symbols' })
    map('n', 'gi', bi.lsp_dynamic_workspace_symbols, { desc = 'workspace symbols' })
    map('n', 'gf', bi.find_files, { desc = 'find files' })

    -- map('n', 'gr', bi.live_grep, { desc = 'live grep' })
    map('n', 'gn', bi.buffers, { desc = 'buffers' })
    map('n', 'go', bi.help_tags, { desc = 'help tags' })
    map('n', 'gm', function()
        bi.man_pages({ sections = { 'ALL' } })
    end, { desc = 'man pages' })
    map('n', 'gt', bi.commands, { desc = 'vim commands' })
    map('n', 'gc', mod.git_diff_files, {})

    map('n', 'gu', function()
        bi.diagnostics({ initial_mode = 'normal', bufnr = 0, severity_limit = vim.diagnostic.severity.ERROR })
    end, { desc = 'lsp diagnostic buffer messages' })
    map('n', 'gU', function()
        bi.diagnostics({ initial_mode = 'normal', bufnr = 0, severity_limit = vim.diagnostic.severity.WARN })
    end, { desc = 'lsp diagnostic buffer messages' })
    map('n', 'g,', function()
        bi.diagnostics({
            initial_mode = 'normal',
            bufnr = nil,
            no_unlisted = false,
            severity_limit = vim.diagnostic.severity.ERROR,
        })
    end, { desc = 'lsp diagnostic all messages' })
end

function mod.git_diff_files(opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local list = vim.fn.systemlist('git diff --name-only master 2>/dev/null | git diff --name-only main')

    pickers
        .new(opts, {
            prompt_title = 'git diff to main/master',
            finder = finders.new_table({ results = list }),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

return mod
