function! plug_helper#install_plug_vim_if_needed()
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    echo 'plug.vim does not exist. Installing...'
    exec '! curl -fsSL --create-dirs -o ~/.vim/autoload/plug.vim ' .
\     'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    source ~/.vim/autoload/plug.vim
  endif
endfunction

function! plug_helper#stub()
  for plug in keys(g:plugs)
    let path = $HOME . '/.vim/plugin/plugged/' . plug . '.vim'
    if !filereadable(path)
      call writefile([], path, 'a')
    endif
  endfor
endfunction

function! plug_helper#unstub()
  for path in glob('~/.vim/plugin/plugged/*.vim', v:false, v:true)
    if getfsize(path) == 0
      call delete(path)
    endif
  endfor
endfunction
