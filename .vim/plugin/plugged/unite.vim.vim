let g:unite_enable_start_insert = 1

nnoremap <silent> <Space>b :<C-u>Unite buffer<CR>
nnoremap <silent> <Space>f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Space>r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> <Space>m :<C-u>Unite file_mru<CR>
nnoremap <silent> <Space>u :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> <Space>t :<C-u>Unite tab<CR>
nnoremap <silent> <Space>a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
