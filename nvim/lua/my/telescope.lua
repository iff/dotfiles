local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'fannheyward/telescope-coc.nvim'
end

function mod.setup()
    local map = vim.api.nvim_set_keymap
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
    })
    require('telescope').load_extension('coc')

    map('', '<leader>,',  ':Telescope git_files<cr>', {})
    map('', '<leader>.',  ':Telescope coc workspace_symbols<cr>', {})
    map('', '<leader>..',  ':Telescope coc document_symbols<cr>', {})


    map('', '<leader>d',  ':Telescope coc definitions<cr>', {})
    map('', '<leader>D',  ':Telescope coc diagnostics<cr>', {})
end

return mod
