local M = {}

-- sync jumper seems to have issues when multiple lsps are running? (switched back to async version for now)
-- local function lsp_jumper(method, before)
--     -- methods (lua vim.print(vim.tbl_keys(vim.lsp.handlers)))
--     --   textDocument/definition
--     return function()
--         local params = vim.lsp.util.make_position_params()
--         local client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
--         local result, _err = vim.lsp.buf_request_sync(0, method, params)
--         if result == nil then
--             return
--         end
--         print(#result)
--         print(client_id)
--         print(result[client_id])
--         result = result[client_id].result
--         if vim.islist(result) then
--             -- TODO we only use the first result
--             -- like the original, it would be better to open quickfix with options?
--             -- or telescope if a certain option is passed
--             result = result[1]
--         end
--         local offset_encoding = vim.lsp.get_client_by_id(client_id).offset_encoding
--         if before then
--             vim.cmd(before)
--         end
--         vim.lsp.util.jump_to_location(result, offset_encoding, false)
--         vim.cmd('normal! zt')
--     end
-- end

local function lsp_jumper(method, before)
    -- methods (lua vim.print(vim.tbl_keys(vim.lsp.handlers)))
    --   textDocument/definition
    return function()
        local params = vim.lsp.util.make_position_params()
        local function handler(_, result, ctx, _)
            -- full signature: err, result, ctx, config
            local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
            if vim.islist(result) then
                -- TODO we only use the first result
                -- like the original, it would be better to open quickfix with options?
                result = result[1]
            end
            if before then
                vim.cmd(before)
            end
            vim.lsp.util.jump_to_location(result, offset_encoding, false)
            vim.cmd('normal! zt')
        end
        -- TODO kinda works, but still async, user might get bored, switches buffer/windows, and then it gets weird
        -- TODO there is now buf_request_sync to make this easier?
        vim.lsp.buf_request(0, method, params, handler)
    end
end

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    M.setup_completion()

    M.setup_lua(capabilities)
    M.setup_python(capabilities)
    M.setup_typescript(capabilities)
    M.setup_clangd(capabilities)
    M.setup_yaml(capabilities)
    M.setup_rust(capabilities)

    vim.diagnostic.config({
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
            -- TODO https://neovim.io/doc/user/diagnostic.html#diagnostic-severity
            severity = { min = vim.diagnostic.severity.WARN },
            prefix = '',
            format = function(diagnostic)
                -- local icons = {"", "", "", ""}
                local icons = { 'E', 'W', 'I', 'H' }
                if diagnostic.code == nil then
                    return icons[diagnostic.severity] .. ' ' .. diagnostic.message
                else
                    return icons[diagnostic.severity] .. '/' .. diagnostic.code
                end
            end,
            update_in_insert = true,
            severity_sort = true,
            spacing = 0,
        },
    })

    vim.cmd([[
        " highlight DiagnosticFloatingError guifg=#3c3836
        highlight DiagnosticVirtualTextError guifg=#bdae93
        highlight DiagnosticUnderlineError gui=undercurl guisp=#cc241d
        highlight DiagnosticSignError guifg=#cc241d
        sign define DiagnosticSignError text=󰅚 texthl=DiagnosticSignError linehl= numhl=

        " highlight DiagnosticFloatingWarn guifg=#3c3836
        highlight DiagnosticVirtualTextWarn guifg=#bdae93
        highlight DiagnosticUnderlineWarn gui=undercurl guisp=#cc241d
        highlight DiagnosticSignWarn guifg=#cc241d
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=

        " highlight DiagnosticFloatingInfo guifg=#3c3836
        highlight DiagnosticVirtualTextInfo guifg=#bdae93
        highlight DiagnosticUnderlineInfo gui=underdotted guisp=#076678
        highlight DiagnosticSignInfo guifg=#076678
        sign define DiagnosticSignInfo text=󰋽 texthl=DiagnosticSignInfo linehl= numhl=

        " highlight DiagnosticFloatingHint guifg=#3c3836
        highlight DiagnosticVirtualTextHint guifg=#bdae93
        highlight DiagnosticUnderlineHint gui=underdotted guisp=#076678
        highlight DiagnosticSignHint guifg=#076678
        sign define DiagnosticSignHint text=󰛩 texthl=DiagnosticSignHint linehl= numhl=

        highlight LspSignatureActiveParameter gui=bold
    ]])
end

function M.setup_completion()
    local cmp = require('cmp')

    cmp.setup({
        view = { entries = { name = 'wildmenu', separator = ' | ' }, docs = { auto_open = true } },
        completion = {
            autocomplete = false,
            -- completeopt = 'menu,menuone',
        },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = {
            ['<c-t>'] = cmp.mapping(
                cmp.mapping.complete({
                    reason = cmp.ContextReason.Auto,
                }),
                { 'i', 'c' }
            ),
            -- TODO try c-t?
            ['<enter>'] = cmp.mapping.confirm({ select = true }),
            ['<c-e>'] = cmp.mapping.select_next_item(),
            ['<c-u>'] = cmp.mapping.select_prev_item(),
            -- ['<c-y>'] = cmp.mapping.open_docs(),
        },
        experimental = {
            ghost_text = true,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
        }),
        formatting = {
            format = require('lspkind').cmp_format({
                mode = 'symbol_text',
                maxwidth = 50,
                menu = {
                    buffer = '[buffer]',
                    nvim_lsp = '[lsp]',
                    nvim_lua = '[lua]',
                },
            }),
        },
    })

    -- enable completing paths in :
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' },
        }),
    })
end

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
    vim.api.nvim_set_option_value('signcolumn', 'yes', {})

    local function nmap(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    local b = vim.lsp.buf

    nmap('tt', lsp_jumper('textDocument/definition'), 'go to definition')
    nmap('ty', lsp_jumper('textDocument/definition', 'tab split'), 'go to definition in a new tab')
    nmap(
        'ti',
        lsp_jumper('textDocument/definition', 'set splitright | vsplit | set splitright!'),
        'go to definition in split right'
    )
    nmap('tn', lsp_jumper('textDocument/definition', 'vsplit'), 'go to definition in split left')
    nmap('te', lsp_jumper('textDocument/definition', 'split'), 'go to definition in split down')
    nmap(
        'tu',
        lsp_jumper('textDocument/definition', 'set splitbelow! | split | set splitbelow!'),
        'go to definition in split up'
    )

    nmap('t.', b.hover, 'hover symbol')
    nmap('tl', b.references, 'find references')
    nmap('t;', b.code_action, 'code action')
    nmap('to', b.rename, 'rename symbol')

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local D = vim.diagnostic
    nmap('tk', function()
        D.jump({ count = -1 })
        vim.cmd('normal! zz')
    end, 'diagnostics previous')
    nmap('th', function()
        D.jump({ count = 1 })
        vim.cmd('normal! zz')
    end, 'diagnostics next')

    -- TODO new keybindings
    -- nmap('tK', D.setqflist, 'diagnostics global qflist')
    -- nmap('tH', D.setloclist, 'diagnostics buffer loclist')

    -- vim.keymap.set('i', '<F11>t', b.signature_help, { buffer = bufnr, desc = 'signature help' })
    require('lsp_signature').on_attach({
        floating_window = false,
        toggle_key = '<F11>t',
    })
end

function M.setup_lua(capabilities)
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    -- TODO does this the right thing? vim seems to resolve last match, but lua originally does first match?

    require('neodev').setup({})

    -- from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    require('lspconfig').lua_ls.setup({
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        on_attach = M.on_attach,
        capabilities = capabilities,
    })
end

function M.setup_python(capabilities)
    require('lspconfig').pyright.setup({
        on_attach = M.on_attach,
        capabilities = capabilities,
        settings = {
            pyright = {
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    autoImportCompletions = true,
                    diagnosticMode = 'workspace',
                    useLibraryCodeForTypes = true,
                },
            },
        },
    })
end

function M.setup_typescript(capabilities)
    require('lspconfig').ts_ls.setup({
        capabilities = capabilities,
    })
end

function M.setup_clangd(capabilities)
    require('lspconfig').clangd.setup({
        capabilities = capabilities,
    })
end

function M.setup_yaml(capabilities)
    require('lspconfig').yamlls.setup({
        capabilities = capabilities,
    })
end

function M.on_attach_rust(client, bufnr)
    local function nmap(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    M.on_attach(client, bufnr)
    nmap('td', ':RustLsp openDocs<CR>', 'go to docs')
end

function M.setup_rust(capabilities)
    vim.g.rustaceanvim = {
        server = {
            on_attach = M.on_attach_rust,
            capabilities = capabilities,
        },
    }
end

return M
