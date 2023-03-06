local mod = {}

local function callback(context)
    if vim.bo.buftype ~= '' then
        -- special buffers (help, terminal, popups, ...) dont need saving
        return
    end
    if string.find(context.file, '^/efs/') ~= nil then
        return
    end
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
