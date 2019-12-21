let g:quickrun_config = {}
let g:quickrun_config['bin/run'] = {'exec': 'run'}

au FileType quickrun nnoremap <silent> <buffer> <ESC><ESC> :q<CR>

