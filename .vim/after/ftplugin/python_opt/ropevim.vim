if !has('python') && v:version >= 700
	finish
endif
function! LoadRope()
	python << EOF
import ropevim
EOF
endfunction

call LoadRope()
