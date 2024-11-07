local leader_map = function()
    vim.g.mapleader = ','
    vim.g.maplocalleader = ','
end

local disable_distribution_plugins = function()
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
end

local options = function()
    local set = vim.opt

    set.writebackup = false
    set.swapfile = false

    set.backspace = { 'indent', 'eol', 'start', 'nostop' }
    set.scrolloff = 9999
    set.jumpoptions = { 'view' }
    set.wildmode = 'longest:full'

    set.tabstop = 4
    set.softtabstop = 4
    set.shiftwidth = 4
    set.expandtab = true
    set.smarttab = true
    set.autoindent = true
    set.copyindent = true
    set.textwidth = 0
    set.indentexpr = ''
    set.indentkeys = ''
    set.cinkeys = ''
    set.formatoptions = ''

    set.modeline = false
    set.modelines = 0

    set.smoothscroll = true
    set.mouse = ''

    set.timeout = false
    set.ttimeout = true

    set.cmdwinheight = 10

    vim.api.nvim_create_autocmd({ 'VimResized' }, {
        desc = 'relayout on resize',
        callback = function()
            local t = vim.api.nvim_get_current_tabpage()
            vim.cmd('tabdo wincmd =')
            vim.api.nvim_set_current_tabpage(t)
        end,
    })
end

local load = function()
    disable_distribution_plugins()
    leader_map()

    require('theme').setup()

    options()

    require('keymap').setup()

    require('Comment').setup()
    require('my/hop').setup()
    require('my/autosave').setup()
    require('my/git').setup()

    require('my/telescope').setup()
    require('my/lspconfig').setup()
    require('my/treesitter').setup()
    require('my/funky').setup()

    -- local hfcc = require('hfcc')
    --
    -- hfcc.setup({
    --     -- api_token = '', -- cf Install paragraph
    --     model = 'bigcode/starcoder', -- can be a model ID or an http(s) endpoint
    --     -- parameters that are added to the request body
    --     query_params = {
    --         max_new_tokens = 60,
    --         temperature = 0.2,
    --         top_p = 0.95,
    --         stop_token = '<|endoftext|>',
    --     },
    --     -- set this if the model supports fill in the middle
    --     fim = {
    --         enabled = true,
    --         prefix = '<fim_prefix>',
    --         middle = '<fim_middle>',
    --         suffix = '<fim_suffix>',
    --     },
    --     debounce_ms = 80,
    --     accept_keymap = '<Tab>',
    --     dismiss_keymap = '<S-Tab>',
    -- })
end

load()
