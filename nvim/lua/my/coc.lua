local M = {}

function M.plugs()
    local Plug = vim.fn['plug#']
    Plug('neoclide/coc.nvim', {['branch'] = 'release'})
end

function M.setup()
end

return M
