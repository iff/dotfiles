local map = vim.api.nvim_set_keymap

map('', ';', ':', {}) -- no shift for cmd mode
map('i', 'jj', '<Esc>', {}) -- no shift for cmd mode
map('', 'gp', '`[v`]', { noremap = true }) -- select last pasted lines
map('', '//', ':nohlsearch<enter>', {}) -- reset search

-- keep selection when indent/outdent
-- xnoremap({ ">", ">gv" })
-- xnoremap({ "<", "<gv" })

-- search for selected text
-- xnoremap({ "*", '"xy/<c-r><cr>' })

-- tab navigation
-- caveat: t is a default mapping for 'until'
map('', 'tt', ':tab split<enter>', {})
map('', 'tT', '<c-w>T', {})
map('', 'tc', ':tabclose<enter>', {})
map('', 'tp', ':tabprevious<enter>', {})
map('', 'tn', ':tabnext<enter>', {})
map('', 'to', ':tabonly<enter>', {})

-- quickfix
-- map('', 'cj', ':cprev<cr>', {})
-- map('', 'ck', ':cnext<cr>', {})

-- Search results centered please
map('', 'n', 'nzz', {})
map('', 'N', 'Nzz', {})
map('', '*', '*zz', {})
map('', '#', '#zz', {})
map('', 'g*', 'g*zz', {})

-- window navigation
-- ',#' goes to window #
-- alternatives ',w#', or just '<c-w>', or just 'w' like tabs go with 't'?
for i = 1, 9 do
    vim.keymap.set('n', ',' .. i, i .. '<c-w>w')
end
