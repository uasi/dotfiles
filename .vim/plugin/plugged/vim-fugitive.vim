nnoremap <silent> <Leader>bl :<C-u>Gblame<CR>
nnoremap <Leader>gg :<C-u>Ggrep<Space>
nnoremap <silent> <Leader>st :<C-u>Gstatus<CR>

function! s:FugitiveMappings()
  if expand('%') == '.git/index'
    nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
  endif
endfunction

au FileType gitcommit call s:FugitiveMappings()
