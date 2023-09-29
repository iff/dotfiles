local mod = {}

local function callback(context)
    if vim.b.autosave == false then
        return
    end

    if
        -- no file
        context.file == ''
        -- special buffers (help, terminal, popups, ...) dont need saving
        or vim.bo.buftype ~= ''
        -- buffers that disappear anyway, probably they are not meant to be saved
        or (vim.bo.bufhidden == 'wipe' or vim.bo.bufhidden == 'delete')
        -- fugitive special buffers (eg, diff view where write means stage changes, do it explicitely)
        or string.find(context.file, '^fugitive://') ~= nil
        -- efs is slow
        or string.find(context.file, '^/efs/') ~= nil
        -- neogit commits the automatic comments in the message when using autosave (?)
        or vim.bo.filetype == 'NeogitCommitMessage'
    then
        vim.b.autosave = false
        return
    end
    vim.b.autosave = true

    -- :update only saves if the file has been modified, no-op otherwise
    -- :silent prevents "xyz bytes write" from popping up everytime, but also hides error messages
    vim.cmd('silent update')
end

function mod.setup()
    -- controls CursorHold and CursorHoldI events
    -- (idle time before they are triggered in milliseconds)
    -- might want to check that it's not set to a longer value again later
    vim.opt.updatetime = 500

    -- checks if files have changed on disk, especially on FocusGained
    vim.opt.autoread = true

    -- interesting events:
    --   InsertLeave, TextChanged, CursorHold
    --   TextChangedI, CursorHoldI, but TextChangedI is on every keystroke
    --   FocusGained, FocusLost (needs terminal or tmux to be configured to send those escape codes)
    local events = { 'InsertLeave', 'TextChanged', 'CursorHold', 'CursorHoldI', 'FocusLost', 'FocusGained' }

    vim.api.nvim_create_autocmd(events, {
        desc = 'autosave',
        callback = callback,
    })
end

return mod
