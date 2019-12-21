let g:bookmark_save_per_working_dir = 1

" Decide bookmarks file location.
" If the current directory is under a git's work tree, place bookmarks file at
" the root of the work tree. Otherwise place at ~/.
function! g:BMWorkDirFileLocation()
  let filename = '.vim_bookmarks'
  let gitdir = finddir('.git', '.;')
  if len(gitdir) > 0
    let location = fnamemodify(gitdir, ':p:h:h')
  else
    let location = $HOME
  end
  return location . '/' . filename
endfunction
