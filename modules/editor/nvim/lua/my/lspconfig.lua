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
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
            severity_sort = true, -- is it working?
            spacing = 0,
        },
    })
end

function M.setup_completion()
    local cmp = require('cmp')

    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = {
            -- enter immediately completes. C-n/C-p to select.
            ['<enter>'] = cmp.mapping.confirm({ select = true }),
        },
        experimental = {
            ghost_text = true,
        },
        -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
        -- TODO removed buffer as source, but still seems to be happening ...
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- TODO should not be here for most filetypes, ah but I think it does it itself
            { name = 'nvim_lua' },
            -- {name='buffer'},
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
    local function nmap(lhs, rhs)
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr })
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local b = vim.lsp.buf
    nmap('gD', b.declaration)
    nmap('gd', b.definition)
    nmap('K', b.hover)
    nmap('gi', b.implementation)
    nmap('<c-k>', b.signature_help)
    nmap('gr', b.references)

    nmap('gv', lsp_jumper('textDocument/definition', 'vsplit'))

    -- nmap('==', b.formatting_seq_sync)
    nmap(',ca', b.code_action)
    nmap(',rn', b.rename)
    nmap('gtd', b.type_definition)

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local D = vim.diagnostic
    nmap(',d', D.open_float)
    nmap('[d', D.goto_prev)
    nmap(']d', D.goto_next)
    nmap(',q', D.setloclist)

    -- get signatures (and _only_ signatures) when in argument lists
    require('lsp_signature').on_attach({
        doc_lines = 0,
        handler_opts = {
            border = 'none',
        },
    })
end

function M.setup_rust(capabilities)
    require('lspconfig').rust_analyzer.setup({
        on_attach = M.on_attach,
        flags = {
            debounce_text_changes = 150,
        },
        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                },
                completion = {
                    postfix = { enable = false },
                },
            },
        },
        capabilities = capabilities,
    })

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    })

    -- type inlay hints
    -- FIXME what does this do?
    vim.cmd("autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }")
end

function M.setup_lua(capabilities)
    -- using sumneko https://github.com/sumneko
    -- alternative language server https://github.com/Alloyed/lua-lsp

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    -- TODO does this the right thing? vim seems to resolve last match, but lua originally does first match?

    -- TODO probably that goes to individual config files or function, one per LSP?
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
        settings = {},
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
