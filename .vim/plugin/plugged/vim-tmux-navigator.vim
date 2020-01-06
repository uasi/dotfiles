let g:tmux_navigator_no_mappings = 1

" Map Control+Arrow keys to navigate through tmux panes.
" Special key names like <C-Left> do not work here, I don't know why.
noremap <silent> [1;5D :TmuxNavigateLeft<Cr>
noremap <silent> [1;5B :TmuxNavigateDown<Cr>
noremap <silent> [1;5A :TmuxNavigateUp<Cr>
noremap <silent> [1;5C :TmuxNavigateRight<Cr>
inoremap <silent> [1;5D <Esc>:TmuxNavigateLeft<Cr>a
inoremap <silent> [1;5B <Esc>:TmuxNavigateDown<Cr>a
inoremap <silent> [1;5A <Esc>:TmuxNavigateUp<Cr>a
inoremap <silent> [1;5C <Esc>:TmuxNavigateRight<Cr>a
