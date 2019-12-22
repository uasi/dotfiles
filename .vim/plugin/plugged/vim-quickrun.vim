let g:quickrun_config = {}
let g:quickrun_config['bin/run'] = {'exec': 'run'}

" Detect buffer local QuickRun type.
" If the last line of the current file contains `quickrun_type = *`,
" this function sets buffer local QuickRun type to the specified type.
function! s:DetectBufLocalQuickRunType()
  let line = getline('$')
  let m = matchlist(line, 'quickrun_type *= *\([^ ]\+\)')
  if len(m) > 0
    let type = m[1]
    let b:quickrun_config = {'type': type}
  end
endfunction
au BufReadPost * call s:DetectBufLocalQuickRunType()

" <ESC><ESC> to quit QuickRun buffer.
au FileType quickrun nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
