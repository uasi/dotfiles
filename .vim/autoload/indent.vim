function! indent#ruby()
	setlocal tabstop=2
	setlocal softtabstop=2
	setlocal shiftwidth=2
	setlocal shiftround
	setlocal expandtab
endfunction

function! indent#python()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
	setlocal shiftround
	setlocal expandtab
endfunction

function! indent#space2()
	setlocal tabstop=2
	setlocal softtabstop=2
	setlocal shiftwidth=2
	setlocal shiftround
	setlocal expandtab
endfunction

function! indent#space4()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
	setlocal shiftround
	setlocal expandtab
endfunction

function! indent#tab2()
	setlocal tabstop=2
	setlocal softtabstop=2
	setlocal shiftwidth=2
	setlocal shiftround
	setlocal noexpandtab
endfunction

function! indent#tab4()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
	setlocal shiftround
	setlocal noexpandtab
endfunction

function! indent#tab8()
	setlocal tabstop=8
	setlocal softtabstop=8
	setlocal shiftwidth=8
	setlocal shiftround
	setlocal noexpandtab
endfunction
