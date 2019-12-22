let g:NERDCommentEmptyLines = 1
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1

nmap <silent> <leader>x :call NERDComment('n', 'Toggle')<CR>
vmap <silent> <leader>x :call NERDComment('v', 'Toggle')<CR>
