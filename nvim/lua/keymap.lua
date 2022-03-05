local map = vim.api.nvim_set_keymap

map('', ';', ':', {})                     -- no shift for cmd mode
map('i', 'jj', '<Esc>', {})               -- no shift for cmd mode
map('', 'gp', '`[v`]', {noremap = true})  -- select last pasted lines
map('', '//', ':nohlsearch<enter>', {})   -- reset search

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
