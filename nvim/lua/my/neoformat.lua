local mod = {}

function mod.plugs()
    local Plug = vim.fn['plug#']
    Plug 'sbdchd/neoformat'
end

function mod.setup()
    local map = vim.api.nvim_set_keymap
    -- neoformat (new fixed by dkuettel)
    --nnoremap == :Black<cr> " Plugin disabled currently, see above
    -- neoformat is buggy:
    -- - multiple formatters in a sequence can cut off the file at the end
    --   see https://github.com/sbdchd/neoformat/pull/235 and https://github.com/sbdchd/neoformat/issues/256
    -- - the working directory is _changed_ to the file being formatted, that makes it hard to discover configurations or venvs
    --   see https://github.com/sbdchd/neoformat/issues/47 (merged unfortunately)
    -- as a workaround:
    -- - use a single executable that chains isort and black
    -- - set a env variable when starting vim for the formatter to use to discover a venv or settings
    -- TODO I dont get anymore a message about changes needed
    vim.g['neoformat_enabled_python'] = {'isort_and_black'}
    vim.g['neoformat_only_msg_on_error'] = 0
    --let g:neoformat_try_formatprg = 1
    vim.cmd [[
      let $vim_project_folder = $PWD
      let g:neoformat_python_isort_and_black = { 'exe': 'isort_and_black', 'args': [], 'stdin': 1 }
    ]]

    vim.g['neoformat_basic_format_align'] = 0
    vim.g['neoformat_basic_format_retab'] = 1
    vim.g['neoformat_basic_format_trim'] = 1

    map('', '==', ':Neoformat<cr>', {})
end

return mod
