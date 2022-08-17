local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'dkuettel/funky-formatter.nvim'
end

function mod.setup()
   local funky_formatter = require("funky-formatter")
   funky_formatter.setup({
      formatters = {
         python = { command = { "isort_and_black" } },
         -- TODO black has "--fast" but it makes no difference, the majority is black (0.23s) not isort (0.06s)
         -- lua = { command = { "stylua", "--config-path", "./stylua.toml", "-" } },
         json = { command = { "jq" } },
         rust = { command = { "rustfmt" } },
      },
   })
   vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return mod
