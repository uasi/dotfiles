function! s:RailsMappings()
	" Map <LocalLeader>Xyy to :RXyyyy
	let prefixes = ['', 'S', 'T', 'V']
	let abbrev_table = {
\		'A': '<CR>',
\		'R': '<CR>',
\		'rr': ' ',
\		'co': 'controller ',
\		'en': 'environment ',
\		'fi': 'fixtures ',
\		'fu': 'functionaltest ',
\		'he': 'helper ',
\		'in': 'initializer ',
\		'it': 'integrationtest ',
\		'ja': 'javascript ',
\		'la': 'layout ',
\		'li': 'lib ',
\		'lo': 'locale ',
\		'ma': 'mailer ',
\		'me': 'metal ',
\		'mi': 'migration ',
\		'mo': 'model ',
\		'ob': 'observer ',
\		'pl': 'plugin ',
\		'sc': 'schema ',
\		'sp': 'spec ',
\		'st': 'stylesheet ',
\		'ta': 'task ',
\		'un': 'unittest ',
\		'vi': 'view '
\	}
	for _p in prefixes
		for _ab in keys(abbrev_table)
			execute "nnoremap <buffer><LocalLeader>" . _p . _ab . " :R" . _p . abbrev_table[_ab]
		endfor
	endfor

	nnoremap <buffer> <LocalLeader>ra :Rake 
endfunction

autocmd User BufEnterRails call s:RailsMappings()
