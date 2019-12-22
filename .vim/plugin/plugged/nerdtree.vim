let g:NERDTreeShowHidden = 1

" Map Ctrl-/ to :NERDTreeToggle.
map <C-_> :NERDTreeToggle<CR>
imap <C-_> <Esc>:NERDTreeToggle<CR>

" Close Vim if the only window left open is a NERDTree.
au BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
