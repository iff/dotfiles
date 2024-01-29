local M = {}

function M.setup()
    vim.cmd('syntax enable')

    vim.opt.background = 'dark'
    vim.cmd('colorscheme nordfox')

    require('nvim-web-devicons').setup({})

    local function window_nr()
        return '%#AlwaysOnWindowNumber#󰐤' .. vim.api.nvim_win_get_number(0)
    end

    local function show_file()
        local file_icons = {
            modified = '',
            unmodified = '󰈖',
            read_only = '',
            autosave = '',
            no_autosave = ' ',
        }

        local icon = nil
        if vim.bo.modifiable then
            if vim.bo.modified then
                icon = file_icons.modified
            else
                icon = file_icons.unmodified
            end
        else
            icon = file_icons.read_only
        end

        local autosave = nil
        if vim.b.autosave == true then
            autosave = file_icons.autosave
        else
            autosave = file_icons.no_autosave
        end

        local name = vim.api.nvim_buf_get_name(0)
        local protocol = string.match(name, '^(.+)://')
        if protocol == nil then
        elseif protocol == 'fugitive' then
            -- (fugitive summary)
            local summary = string.match(name, 'git//$')
            -- (at commit, thats always [index] in a diff?)
            local at = string.match(name, 'git//(%w+)/')
            if summary ~= nil then
                protocol = protocol .. '@summary'
            elseif at ~= nil then
                protocol = protocol .. '@' .. string.sub(at, 1, 7)
            else
                protocol = protocol .. '@?'
            end
        else
            protocol = protocol .. '?'
        end

        if protocol == nil then
            protocol = ''
        else
            protocol = protocol .. '://'
        end

        return icon .. autosave .. ' ' .. protocol .. '%t'
    end

    require('lualine').setup({
        options = {
            theme = 'nightfox',
            icons_enabled = false,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            always_divide_middle = true,
            globalstatus = false,
        },
        sections = {
            lualine_a = { show_file },
            -- lualine_a = { window_nr, show_file },
            lualine_b = { { 'diff', icon = '', colored = false } },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { { 'diagnostics', sources = { 'nvim_lsp' }, colored = false } },
            lualine_z = {
                -- function()
                --     return lsp_indicator.get_state(0)
                -- end,
                { 'filetype', icons_enabled = false },
                'location',
            },
        },
        inactive_sections = {
            lualine_a = { show_file },
            -- lualine_a = { window_nr, show_file },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {
            lualine_a = {
                function()
                    return '[' .. (vim.g.funky_context or '...') .. ']'
                end,
            },
            lualine_b = {
                {
                    'tabs',
                    max_length = vim.o.columns,
                    show_modified_status = false,
                },
            },
        },
        extensions = {},
    })

    -- custom diagnostics
    vim.cmd([[
       highlight DiagnosticFloatingError guifg=#3c3836
       highlight DiagnosticVirtualTextError guifg=#bdae93
       highlight DiagnosticUnderlineError gui=undercurl guisp=#cc241d
       highlight DiagnosticSignError guifg=#cc241d
       sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=

       highlight DiagnosticFloatingWarn guifg=#3c3836
       highlight DiagnosticVirtualTextWarn guifg=#bdae93
       highlight DiagnosticUnderlineWarn gui=undercurl guisp=#cc241d
       highlight DiagnosticSignWarn guifg=#cc241d
       sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=

       highlight DiagnosticFloatingInfo guifg=#3c3836
       highlight DiagnosticVirtualTextInfo guifg=#bdae93
       highlight DiagnosticUnderlineInfo gui=undercurl guisp=#076678
       highlight DiagnosticSignInfo guifg=#076678
       sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=

       highlight DiagnosticFloatingHint guifg=#3c3836
       highlight DiagnosticVirtualTextHint guifg=#bdae93
       highlight DiagnosticUnderlineHint gui=undercurl guisp=#076678
       highlight DiagnosticSignHint guifg=#076678
       sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=

       highlight LspSignatureActiveParameter gui=bold
    ]])
end

return M
