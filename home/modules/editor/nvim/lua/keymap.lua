local M = {}

function M.setup()
    M.general()

    -- TODO don't activate uncoditionally
    M.colemak()
end

function M.general()
    local map = vim.api.nvim_set_keymap

    map('', ';', ':', {}) -- no shift for cmd mode
    -- map('i', 'hh', '<Esc>', {})
    map('', 'wp', '`[v`]', { noremap = true }) -- select last pasted lines

    -- window navigation
    -- ',#' goes to window #
    -- alternatives ',w#', or just '<c-w>', or just 'w' like tabs go with 't'?
    for i = 1, 9 do
        vim.keymap.set('n', ',' .. i, i .. '<c-w>w')
    end
end

function M.mappings()
    -- keep selection when indent/outdent
    -- xnoremap({ ">", ">gv" })
    -- xnoremap({ "<", "<gv" })

    -- search for selected text
    -- xnoremap({ "*", '"xy/<c-r><cr>' })

    -- quickfix
    -- map('', 'cj', ':cprev<cr>', {})
    -- map('', 'ck', ':cnext<cr>', {})

    -- Search results centered please
    -- map('', 'n', 'nzz', {})
    -- map('', 'N', 'Nzz', {})
    -- map('', '*', '*zz', {})
    -- map('', '#', '#zz', {})
    -- map('', 'g*', 'g*zz', {})
end

function M.get_maps()
    -- consider https://colemakmods.github.io/mod-dh/model.html

    local maps = {}

    maps['inverted T arrows'] = {
        nv = {
            { 'n', 'h' }, -- cursor left
            { 'e', 'j' }, -- cursor down
            { 'i', 'l' }, -- cursor right
            { 'u', 'k' }, -- cursor up
        },
    }

    maps['browse'] = {
        nv = {
            { '<c-u>', 'kzz' }, -- view and cursor up
            { '<c-e>', 'jzz' }, -- view and cursor down
            { 'zz', 'zz' }, -- center line in view
            { 'ze', 'zb' }, -- line at top of view
            { 'zu', 'zt' }, -- line at botton of view
            { 'k', ':set scroll=0<enter><c-u><c-u>' }, -- view and cursor one page up
            { 'h', ':set scroll=0<enter><c-d><c-d>' }, -- view and cursor one page down
        },
    }

    maps['insert'] = {
        n = {
            { 'sn', 'i' }, -- insert before block cursor
            { 'se', 'o' }, -- insert new line below
            { 'su', 'O' }, -- insert new line above
            { 'si', 'a' }, -- append after block cursor
            { 'so', 'A' }, -- append at end of line
            { 'sm', '^i' }, -- insert at beginning of line
            { 'sl', 'lbi' }, -- insert at beginning of word
            { 'sy', 'hea' }, -- append at end of word
            { 'p', 'r' }, -- single replace
        },
    }

    maps['change'] = {
        n = {
            -- TODO have it in f instead? and ff for r?
            -- or ss is r
            { 'ss', 'c' },
        },
    }

    maps['right hand operators'] = {
        o = {
            { 'e', 'iw' }, -- inner word
            { 'E', 'iW' }, -- inner Word
            { 'i', '$' }, -- to end of line
            { 'n', 'Vl' }, -- line
            { '(', 'i(' }, -- inner ()
            { ')', 'a(' }, -- outer ()
            { '[', 'i[' }, -- inner []
            { ']', 'a[' }, -- outer []
            { '{', 'i{' }, -- inner {}
            { '}', 'a{' }, -- outer {}
            { "'", "i'" }, -- inner ''
            { '\\', "a'" }, -- outer ''
            { '"', 'i"' }, -- inner ""
            { '|', 'a"' }, -- outer ""
            { '.', 'l' }, -- one character
            { 'y', 'e' }, -- to end of word
            { 'Y', 'E' }, -- to end of Word
            { 'l', 'b' }, -- to start of word
            { 'L', 'B' }, -- to start of Word
            -- TODO from here maybe longer sequences prefixed with l or u or y
            -- like argument, or body, or other python objects
        },
    }

    -- TODO add that to arrows at the top? same topic
    maps['moves'] = {
        nv = {
            -- { "gn", "^" }, -- start of text in line
            { 'm', '^' }, -- start of text in line
            -- TODO could also use mlyo and co, it not needed for some
            -- they might be quite natural
            -- { "ggn", "0" }, -- start of line
            { '<c-m>', '0' }, -- start of line
            -- { "gi", "$" }, -- end of line
            { 'o', '$' }, -- end of line
            -- { "gu", "gg" }, -- top of document
            { '<c-k>', 'gg' }, -- top of document
            -- { "ggu", "gg0" }, -- top left of document
            { 'j', 'gg0' }, -- top left of document
            -- { "ge", "G" }, -- bottom of document
            { '<c-h>', 'G' }, -- bottom of document
            -- { "<c-i>", "w" }, -- word
            -- { "<c-o>", "W" }, -- Word
            -- { "<c-n>", "b" }, -- reverse word
            -- { "<c-m>", "B" }, -- reverse Word
            -- { "<s-i>", "e" }, -- end of word
            -- { "<s-o>", "E" }, -- End of word
            -- { "<s-n>", "ge" }, -- reverse end of word
            -- { "<s-m>", "gE" }, -- reverse end of Word
            -- TODO should those move into the middles of the words?
            { 'l', 'b' }, -- word back
            { 'L', 'B' }, -- Word back
            { 'y', 'w' }, -- word forward
            { 'Y', 'W' }, -- Word forward
        },
    }

    maps['undo'] = {
        n = {
            { 'qq', 'u' },
            { 'qw', '<c-r>' },
        },
    }

    maps['copy'] = {
        nv = {
            { 'w', 'y' },
            { 'ww', 'yy' },
        },
        n = {
            { 'wf', 'p' },
            { 'WF', 'P' },
        },
    }

    maps['search'] = {
        n = {
            { 'fe', '/' },
            { 'fu', '?' },
            -- TODO gonna be harder here to use operator mode?
            -- { "fe", "viw*" }, -- TODO as an example
            -- { "fpe", "viw#" }, -- TODO as an example
            -- TODO could overload kh or ue or so? just for as long as search is active
            -- { "ft", "n" },
            -- { "FT", "N" },
            { 'E', 'nzz' },
            { 'U', 'Nzz' },
            -- { "FP", "<cmd>nohlsearch<enter>" },
            { 'ff', '<cmd>nohlsearch<enter>' },
        },
    }

    maps['delete'] = {
        nv = {
            { 'd', 'd' },
        },
    }

    maps['tabs'] = {
        n = {
            { 'ftu', '<cmd>tab split<enter>' }, -- new tab
            { 'ftU', '<c-w>T' }, -- explode into new tab
            { 'ftn', '<cmd>tabprevious<enter>' }, -- previous tab
            { 'fti', '<cmd>tabnext<enter>' }, -- next tab
            { 'ft,', '<cmd>tabclose<enter>' }, -- close tab
            { 'ft.', '<cmd>tabonly<enter>' }, -- only tab
            { 'ft;', 'g<tab>' }, -- last tab
            { 'ftl', '<cmd>tabmove -1<enter>' }, -- move tab left
            { 'fty', '<cmd>tabmove +1<enter>' }, -- move tab right
            -- TODO consider ft{digit} for go to
            -- and ft{s-digit} for move tab to
            -- or not needed often enough? keep it in the cmd line?
        },
    }

    maps['splits'] = {
        n = {
            { 'sti', '<cmd>vsplit<enter>' }, -- split right
            { 'stn', '<cmd>set splitright! | vsplit | set splitright!<enter>' }, -- split left
            { 'ste', '<cmd>split<enter>' }, -- split down
            { 'stu', '<cmv>set splitbelow! | split | set splitbelow!<enter>' }, -- split up
            { 'st,', '<c-w>c' }, -- close split
            { 'st<', '<cmd>x<enter>' }, -- TODO needed? have a write & close/delete buffer? needed in fugitive commit messages
            { 'st.', '<c-w>o' }, -- only split
            { 'sth', '<c-w>w' }, -- last split
            -- TODO add st{digit}
        },
    }

    -- NOTE lsp is all behind t, is there an easy way to have keys defined centrally?

    -- TODO looking for
    -- q to generally quit? window or tab? qq and qw? move undo then
    -- in an effort to make it similar with fugitive, but could instead make ,x or tsx there too?
    -- how to get those: windows, tabs, and all the go-to stuff (mostly lsp)
    -- especially goto: some leader plus
    --   - right hand for default operation with desired split
    --   - double for either default splitting
    --     - or for pop up preview and then right hand, or leader again for quit/return

    return maps
end

function M.colemak()
    local maps = M.get_maps()
    M.apply_maps(maps)

    -- TODO generally go for alternating and rolling sequences

    -- TODO we could also consider the original stuff behind a leader? in case we need it

    vim.cmd([[
        " visual
        " noremap vv V
        " noremap vs v
        " ideas for text operations
        " noremap p r
        " noremap ss ciw
        " noremap cc cc
    ]])
end

function M.apply_maps(maps, opts)
    for _, sections in pairs(maps) do
        for modes, binds in pairs(sections) do
            modes = vim.iter(string.gmatch(modes, '.')):totable()
            for _, bind in ipairs(binds) do
                vim.keymap.set(modes, bind[1], bind[2], opts)
            end
        end
    end
end

return M
