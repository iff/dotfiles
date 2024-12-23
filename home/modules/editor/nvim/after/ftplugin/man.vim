" use this to find an entry interactively
" TODO could also do something with telescope if we parse it using some
" heuristics
nmap <buffer> f /\C^ *
nmap <buffer> - /\C^ *-

" see also /usr/local/share/nvim/runtime/ftplugin/man.vim
nnoremap <silent> <buffer> k <cmd>set scroll=0<enter><c-u><c-u>
nnoremap <silent> <buffer> h <cmd>set scroll=0<enter><c-d><c-d>
" TODO this mapping is not very well aligned yet
" not bad, a bit hacky to "hide" the filename column
nnoremap <silent> <buffer> go <cmd>lua require("man").show_toc()<enter><c-w>c<cmd>lua require("telescope.builtin").loclist({fname_width=0})<enter>
