if !exists('g:quickrun')
	finish
endif

nnoremap <buffer> <silent> <Leader>t :<C-u>QuickRun -mode n -type test:<C-r>=&filetype<CR><CR>

let s:quickrun_test_config = {}

let d_type = copy(g:quickrun#default_config['d']['type'])
if d_type != ''
	let s:quickrun_test_config[d_type] = copy(g:quickrun#default_config[d_type])
	let s:quickrun_test_config[d_type]['cmdopt'] = '-unittest'
endif

let s:quickrun_test_config['rust'] = copy(g:quickrun#default_config['rust'])
let s:quickrun_test_config['rust']['cmdopt'] = '--test'

for k in keys(s:quickrun_test_config)
	let g:quickrun_config['test:' . k] = s:quickrun_test_config[k]
endfor
