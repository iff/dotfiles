local is_day = function()
    return vim.fn.system("tail -n 2 $HOME/.log-redshift | cut -d' ' -f5 | tr -d '\n'") == '5700K'
end

local M = {}

function M.plugs()
    local Plug = vim.fn['plug#']

    -- Plug('morhetz/gruvbox')
    Plug('EdenEast/nightfox.nvim', { ['branch'] = 'main' })

    Plug('kyazdani42/nvim-web-devicons') -- icons
    Plug('nvim-lualine/lualine.nvim')
end

function M.setup()
    vim.opt.background = 'dark'
    vim.cmd('syntax enable')

    -- vim.cmd('colorscheme gruvbox')
    -- vim.cmd('colorscheme nordfox')
    -- vim.cmd('colorscheme dawnfox')

    if is_day() then
        vim.opt.background = 'light'
        vim.cmd('colorscheme dawnfox')
    else
        vim.opt.background = 'dark'
        vim.cmd('colorscheme nordfox')
    end

    -- lualine
    -- require('lualine').setup {options = { theme = 'gruvbox' }}
    -- require('lualine').setup {options = { theme = 'nightfox' }}
    require('nvim-web-devicons').setup({})

    local function window_nr()
        return '#' .. vim.api.nvim_win_get_number(0)
    end

    require('lualine').setup({
        options = {
            theme = 'nightfox',
            icons_enabled = false,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {},
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { window_nr },
            lualine_b = { 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = {},
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        inactive_sections = {
            lualine_a = { window_nr },
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {
            lualine_a = {
                function()
                    return '[' .. (vim.g.funky_context or '...') .. ']'
                end,
            },
            lualine_b = { 'tabs' },
        },
        extensions = { 'quickfix' },
    })

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
