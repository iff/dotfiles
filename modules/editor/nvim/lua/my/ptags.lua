local mod = {}

function mod.plugs() end

function mod.setup()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    local kinds = { ['function'] = ' func', ['variable'] = '  var', ['class'] = 'class' }
    local function pdocs_entry_maker(raw_line)
        local name, line, kind, file = string.match(raw_line, '^(.*)%z(.*)%z(.*)%z(.*)$')
        line = tonumber(line)
        kind = kinds[kind]
        if not kind then
            kind = '???'
        end
        local display = kind .. ': ' .. name
        return {
            value = { name = name, line = line, kind = kind, file = file },
            display = display,
            ordinal = display,
            path = file,
            lnum = line,
            col = 0,
        }
    end

    local function ptags(sources, opts)
        if not sources then
            -- TODO for now no ./.pdocs or ./.list-symbols, just try to discover things
            local Path = require('plenary.path')
            if Path:new('python'):is_dir() then
                sources = { 'python' }
            elseif Path:new('src'):is_dir() then
                sources = { 'src' }
            else
                sources = { '.' }
            end
        end
        local pdocs_command = {
            'ptags',
            '--out=-',
            '--fmt=vim-telescope',
            '--quiet',
            unpack(sources),
        }
        opts = opts or {}
        pickers
            .new(opts, {
                prompt_title = 'ptags',
                finder = finders.new_oneshot_job(pdocs_command, {
                    entry_maker = pdocs_entry_maker,
                }),
                sorter = conf.generic_sorter(opts),
                previewer = conf.grep_previewer(opts),
            })
            :find()
    end

    -- TODO this sets the mapping globally
    vim.keymap.set('n', ',..', function()
        ptags({ vim.fn.expand('%') })
    end)
    vim.keymap.set('n', ',.', ptags)
end

return mod
