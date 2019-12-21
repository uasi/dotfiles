function! plug_helper#stub()
  for plug in keys(g:plugs)
    let path = $DOTVIM . '/plugin/plugged/' . plug . '.vim'
    if !filereadable(path)
      call writefile([], path, 'a')
    endif
  endfor
endfunction

function! plug_helper#unstub()
  for path in glob(escape($DOTVIM, '?*[]') . '/plugin/plugged/*.vim', v:false, v:true)
    if getfsize(path) == 0
      call delete(path)
    endif
  endfor
endfunction
