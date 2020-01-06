let g:tmux_navigator_no_mappings = 1

" Map Shift+Arrow keys to navigate through tmux panes.
" Special key names like <S-Left> do not work here, I don't know why.
noremap <silent> [1;2D :TmuxNavigateLeft<Cr>
noremap <silent> [1;2B :TmuxNavigateDown<Cr>
noremap <silent> [1;2A :TmuxNavigateUp<Cr>
noremap <silent> [1;2C :TmuxNavigateRight<Cr>
inoremap <silent> [1;2D <Esc>:TmuxNavigateLeft<Cr>a
inoremap <silent> [1;2B <Esc>:TmuxNavigateDown<Cr>a
inoremap <silent> [1;2A <Esc>:TmuxNavigateUp<Cr>a
inoremap <silent> [1;2C <Esc>:TmuxNavigateRight<Cr>a
