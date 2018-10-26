" Load optional modules if vim has been compiled with python support.

if has('python')
	set runtimepath+=$HOME/.vim/after/ftplugin/python_opt
end
