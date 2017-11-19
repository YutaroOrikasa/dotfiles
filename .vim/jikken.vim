inoremap <CR> X
inoremap <TAB> T
" imap <expr><CR> pumvisible() && neosnippet#expandable() ? 
" 			\ "\<Plug>(neosnippet_expand_or_jump)" : "<CR>"
" imap <expr><CR> pumvisible() && neosnippet#expandable() ?  "\<TAB>" : "\<CR>"
imap <expr><CR> pumvisible() ?  "\<TAB>" : "\<CR>"
" imap <expr><CR> 1 ?  "\<TAB>" : "\<CR>"

