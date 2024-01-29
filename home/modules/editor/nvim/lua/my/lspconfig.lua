local M = {}

-- from looking at
--   nvim/runtime/lua/vim/lsp/buf.lua
--   nvim/runtime/lua/vim/lsp/handlers.lua
--   nvim/runtime/lua/vim/lsp/util.lua
-- all the lsp jumps are done async, but I need it sync
-- and there is no option to control this
-- I want: sync, optional splits or tabs before, move target line to the top (like "zt")
local function lsp_jumper(method, before)
    -- methods
    --   textDocument/definition
    return function()
        local params = vim.lsp.util.make_position_params()
        local function handler(_, result, ctx, _)
            -- full signature: err, result, ctx, config
            local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
            if vim.tbl_islist(result) then
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
        vim.lsp.buf_request(0, method, params, handler)
    end
end

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    M.setup_completion()

    M.setup_rust(capabilities)
    M.setup_lua(capabilities)
    M.setup_python(capabilities)
    M.setup_typescript(capabilities)
    M.setup_rnix(capabilities)
    M.setup_clangd(capabilities)
    M.setup_yaml(capabilities)

    vim.diagnostic.config({
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
            -- TODO https://neovim.io/doc/user/diagnostic.html#diagnostic-severity
            severity = { min = vim.diagnostic.severity.WARN },
            prefix = '', -- alternatives ﲑﲒﲕﲖ
            format = function(diagnostic)
                -- local icons = {"", "", "", ""}
                local icons = { 'E', 'W', 'I', 'H' }
                if diagnostic.code == nil then
                    return icons[diagnostic.severity] .. ' ' .. diagnostic.message
                else
                    return icons[diagnostic.severity] .. '/' .. diagnostic.code
                end
            end,
            -- TODO doesnt seem to disable, which signs are they? I want to change them
            -- signs = false,
            -- TODO doesnt seem to apply to open_float ...
            -- float = {
            --     prefix = function(diagnostics, i, total)
            --         return "somee: "
            --     end,
            -- },
            -- TODO not sure I see an effect either way, with false it was maybe flickery and out of date?
            update_in_insert = true,
            severity_sort = true,
            spacing = 0,
        },
    })
end

function M.setup_completion()
    local cmp = require('cmp')

    cmp.setup({
        view = { entries = { name = 'wildmenu', separator = ' | ' }, docs = { auto_open = true } },
        completion = {
            autocomplete = false,
            completeopt = 'menu,menuone',
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
            ['<enter>'] = cmp.mapping.confirm({ select = true }),
            ['<c-i>'] = cmp.mapping.select_next_item(),
            ['<c-n>'] = cmp.mapping.select_prev_item(),
            -- ['<c-u>'] = cmp.mapping.open_docs(),
        },
        experimental = {
            ghost_text = true,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
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
    -- vim.api.nvim_set_option_value('signcolumn', 'yes')

    local function nmap(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end
    local function imap(lhs, rhs, desc)
        vim.keymap.set('i', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local b = vim.lsp.buf
    -- TODO
    -- nmap('gD', b.declaration)
    -- nmap('gi', b.implementation)
    -- nmap('gtd', b.type_definition)

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
    imap('<c-k>', b.signature_help, 'signature help')
    nmap('tl', b.references, 'find references')
    nmap('t;', b.code_action, 'code action')
    nmap('to', b.rename, 'rename symbol')

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local D = vim.diagnostic
    nmap('t,', function()
        D.open_float({
            prefix = function(d, i, t)
                return vim.diagnostic.severity[d.severity] .. ': '
            end,
        })
    end, 'diagnostics float')
    nmap('tk', function()
        D.goto_prev()
        vim.cmd('normal! zz')
    end, 'diagnostics previous')
    nmap('th', function()
        D.goto_next()
        vim.cmd('normal! zz')
    end, 'diagnostics next')
    nmap('tK', D.setqflist, 'diagnostics global qflist')
    nmap('tH', D.setloclist, 'diagnostics buffer loclist')

    -- get signatures (and _only_ signatures) when in argument lists
    require('lsp_signature').on_attach({
        doc_lines = 0,
        handler_opts = {
            border = 'none',
        },
    })
end

function M.setup_rust(capabilities)
    -- require('lspconfig').rust_analyzer.setup({
    --     on_attach = M.on_attach,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     settings = {
    --         ['rust-analyzer'] = {
    --             cargo = {
    --                 allFeatures = true,
    --             },
    --             completion = {
    --                 postfix = { enable = false },
    --             },
    --         },
    --     },
    --     capabilities = capabilities,
    -- })

    local rt = require('rust-tools')
    rt.setup({
        tools = {
            inlay_hints = {
                only_current_line = true,
            },
        },
        server = {
            on_attach = function(client, bufnr)
                M.on_attach(client, bufnr)
                -- Hover actions
                vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
        },
    })

    -- vim.cmd("autocmd CursorHold,CursorHoldI *.rs :lua require'rust-tools'.inlay_hints.enable()")
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
    require('lspconfig').tsserver.setup({
        capabilities = capabilities,
    })
end

function M.setup_rnix(capabilities)
    require('lspconfig').rnix.setup({
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

return M
