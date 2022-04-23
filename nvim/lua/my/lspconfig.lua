local M = {}

function M.plugs()
    local Plug = vim.fn['plug#']

    Plug('neovim/nvim-lspconfig')
    Plug 'nvim-lua/lsp_extensions.nvim'

    Plug('hrsh7th/cmp-nvim-lsp', {['branch'] = 'main'})
    Plug('hrsh7th/cmp-buffer', {['branch'] = 'main'})
    Plug('hrsh7th/cmp-path', {['branch'] = 'main'})
    Plug('hrsh7th/nvim-cmp', {['branch'] = 'main'})
    Plug('ray-x/lsp_signature.nvim')

    -- Only because nvim-cmp _requires_ snippets
    -- Plug('hrsh7th/cmp-vsnip', {['branch'] = 'main'})
    -- Plug('hrsh7th/vim-vsnip')
    -- whats the difference to the above?
    Plug('L3MON4D3/LuaSnip')
    Plug('saadparwaiz1/cmp_luasnip')

    -- Rust
    -- https://github.com/Saecki/crates.nvim
    -- Plug('rust-lang/rust.vim') -- don't want such a huge plugin?

    -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    -- Plug("cmp-cmdline")
    -- Plug("lspkind-nvim") -- piktograms

    -- could be interesting to show more info from lsp
    -- https://github.com/nvim-lua/lsp-status.nvim
end


function M.setup()
    -- TODO not sure why that is needed
    -- from https://github.com/hrsh7th/nvim-cmp/#setup
    -- that makes vim the client say it can accept more from the LS?
    local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

    M.setup_completion()

    M.setup_rust(capabilities)
    M.setup_lua(capabilities)
end


function M.setup_completion()
  local cmp = require('cmp')

  cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
      -- enter immediately completes. C-n/C-p to select.
      ['<enter>'] = cmp.mapping.confirm({ select = true })
    },
    experimental = {
      ghost_text = true,
    },
    -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    -- TODO removed buffer as source, but still seems to be happening ...
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        -- TODO should not be here for most filetypes, ah but I think it does it itself
        { name = "nvim_lua" },
        -- {name='buffer'},
    }),
    -- formatting = {
    --     format = require("lspkind").cmp_format({
    --         mode = "symbol_text",
    --         maxwidth = 50,
    --         menu = {
    --             buffer = "[buffer]",
    --             nvim_lsp = "[lsp]",
    --             nvim_lua = "[lua]",
    --         },
    --     }),
    -- },
  })

  -- enable completing paths in :
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    })
  })
end

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
    },
  })
end

function M.setup_rust(capabilities)
  local lspconfig = require('lspconfig')

  lspconfig.rust_analyzer.setup {
    on_attach = M.on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        completion = {
          postfix = { enable = false },
        },
      },
    },
    capabilities = capabilities,
  }

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      signs = true,
      update_in_insert = true,
    }
  )

  -- type inlay hints
  -- FIXME what does this do?
  vim.cmd("autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }")
end

function M.setup_lua(capabilities)
    -- using sumneko https://github.com/sumneko
    -- alternative language server https://github.com/Alloyed/lua-lsp

    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    -- TODO does this the right thing? vim seems to resolve last match, but lua originally does first match?

    -- TODO probably that goes to individual config files or function, one per LSP?
    -- from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    require("lspconfig").sumneko_lua.setup({
        cmd = { os.getenv("HOME") .. "/bin/sumneko/bin/lua-language-server" },
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        on_attach = M.mappings,
        capabilities = capabilities,
    })
end

return M
