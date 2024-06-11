local M = {}

function M.setup()
    M.general()
    M.setup_term_runners()

    M.colemak()
end

function M.general()
    local map = vim.api.nvim_set_keymap

    map('', ';', ':', {}) -- no shift for cmd mode

    -- TODO configure new keybinding
    -- disable some original mappings
    for _, k in pairs({ 'q', 'a', 'Q' }) do
        vim.keymap.set('', k, '<nop>')
    end

    -- window navigation
    -- ',#' goes to window #
    -- alternatives ',w#', or just '<c-w>', or just 'w' like tabs go with 't'?
    for i = 1, 9 do
        vim.keymap.set('n', ',' .. i, i .. '<c-w>w')
    end

    -- FIXME not sure why I need to rebind this?
    vim.keymap.set('n', '<CR>', function()
        if vim.o.buftype == 'quickfix' then
            return ':.cc<CR>'
        else
            -- TODO maybe bind something interesting here?
            return '<CR>'
        end
    end, { expr = true, replace_keycodes = true })

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

function M.setup_term_runners()
    local map = vim.api.nvim_set_keymap

    map('n', '<leader>g', ":vsplit | term zsh -c '$(pwd)/.tmux/g'<CR>", { noremap = true, silent = true })

    -- make sure we always scroll to the last line in term buffers
    vim.cmd([[
      augroup TermScroll
        autocmd!
        autocmd BufWinEnter,WinEnter term://* startinsert | autocmd BufWritePost <buffer> normal! G
        autocmd TermOpen * startinsert
      augroup END
    ]])

    -- exit insert mode in terminal with an easier shortcut
    -- or use c-,
    vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]])
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
            { '<c-u>', '1<c-u>' }, -- view and cursor up
            { '<c-e>', '1<c-d>' }, -- view and cursor down
            -- { '<c-u>', 'kzz' }, -- view and cursor up
            -- { '<c-e>', 'jzz' }, -- view and cursor down
            { 'zz', 'zz' }, -- center line in view
            { 'ze', 'zb' }, -- line at top of view
            { 'zu', 'zt' }, -- line at botton of view
            { 'k', '<cmd>set scroll=0<enter><c-u><c-u>' }, -- view and cursor one page up
            { 'h', '<cmd>set scroll=0<enter><c-d><c-d>' }, -- view and cursor one page down
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
            { 'sL', 'lBi' }, -- insert at beginning of Word
            { 'sy', 'hea' }, -- append at end of word
            { 'sY', 'hEa' }, -- append at end of Word
        },

        v = {
            { 's', 'c' },
        },
    }

    maps['change'] = {
        n = {
            { 'r', 'c' },
            { 'rr', 'r' },
            { '<c-n>', '<<' },
            { '<c-i>', '>>' },
        },
        v = {
            { 'r', 'c' },
            { '<c-n>', '<gv' },
            { '<c-i>', '>gv' },
        },
    }

    maps['right hand operators'] = {
        o = {
            { 'e', 'iw' }, -- inner word
            { 'E', 'iW' }, -- inner Word
            { 'u', 'aw' }, -- inner word with connecting whitespace
            { 'U', 'aW' }, -- inner word with connecting whitespace
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
        },
    }

    maps['moves'] = {
        nv = {
            { 'm', '0^' }, -- start of text in line
            { '<c-m>', '0' }, -- start of line
            { 'o', '$' }, -- end of line
            { '<c-k>', 'gg' }, -- top of document
            { '<c-h>', 'G' }, -- bottom of document
            { 'l', 'b' }, -- word back
            { 'L', 'B' }, -- Word back
            { 'y', 'w' }, -- word forward
            { 'Y', 'W' }, -- Word forward
        },
    }

    maps['undo'] = {
        n = {
            { 'qn', 'u' },
            { 'qi', '<c-r>' },
        },
    }

    maps['copy'] = {
        nv = {
            { 'c', '"zy' },
            { 'x', '"zd' }, -- copy and cut
            { 'ca', '"+y' }, -- put into system clipboard
            { '<c-c>u', [["yy'<"yP]] }, -- duplicate above
            { '<c-c>e', [["yy'>"yp]] }, -- duplicate below
        },
        n = {
            { 'pu', '"zP' },
            { 'pn', '"zP' },
            { 'pe', '"zp' },
            { 'pi', '"zp' },
            { 'pv', '`[v`]' }, -- select last pasted lines
            -- { 'wa', '[["+Y]]' }, -- put into system clipboard
        },
        v = {
            { 'p', '"zp' }, -- replace
        },
    }

    maps['search'] = {
        n = {
            { 'fi', '/' },
            { 'fn', '?' },
            { 'fy', '*' }, -- search word forward
            { 'fl', '#' }, -- search word backward
            { 'E', 'nzz' },
            { 'U', 'Nzz' },
            { 'f,', '<cmd>nohlsearch<enter>' },
        },
    }

    maps['delete'] = {
        nv = {
            { 'd', 'd' },
            -- { 'D', '"_d' },
        },
    }

    maps['visual'] = {
        nv = {
            { 'v', 'V' }, -- using line select more often
            { 'V', 'v' },
        },
    }

    maps['tabs'] = {
        n = {
            -- { 'ftu', '<cmd>tab split<enter>' }, -- new tab
            -- { 'ftU', '<c-w>T' }, -- explode into new tab
            { 'ftn', '<cmd>tabprevious<enter>' }, -- previous tab
            { 'fti', '<cmd>tabnext<enter>' }, -- next tab
            { 'ft,', '<cmd>tabclose<enter>' }, -- close tab
            { 'ft.', '<cmd>tabonly<enter>' }, -- only tab
            { 'fth', 'g<tab>' }, -- last tab
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
            { 'sty', '<cmd>tab split<enter>' }, -- new tab
            { 'stY', '<c-w>T' }, -- explode into new tab
            { 'st,', '<cmd>wincmd c | wincmd=<enter>' }, -- close split
            { 'st.', '<cmd>wincmd o | wincmd=<enter>' }, -- only split, close all other splits
            { 'sth', '<c-w>p' }, -- last split
            { 'stt', '1<c-w>w' }, -- split #1
            { 'sts', '2<c-w>w' }, -- split #2
            { 'str', '3<c-w>w' }, -- split #3
            { 'sta', '4<c-w>w' }, -- split #4
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
