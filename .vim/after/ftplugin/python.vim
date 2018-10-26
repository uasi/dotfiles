"-- Options ------------------------------------------------------------------
call indent#space4()

"setlocal omnifunc=pysmell#Complete

"-- Mappings -----------------------------------------------------------------
inoremap <buffer> <S-Tab> <c-r>=BeginOmniComplWithTab()<cr>
imap <buffer> <C-B> <C-X><C-O>

"--- Abbreviations -----------------------------------------------------------

" Statements
ia <buffer> I import
ia <buffer> FI from import *<Esc>8hi
ia <buffer> ALL __all__ = []<Left><C-R>=Eatspace()<CR>

ia <buffer> MAIN if __name__ == '__main__':<CR>main()
ia <buffer> TEST if __name__ == '__main__':<CR>test()
" Note: <Esc>==A means 'reformat(reindent) the line.'
" This won't take effect after 'def ...'
ia <buffer> E except Exception, e:<Esc>==A
ia <buffer> W while True:<C-R>=Eatspace()<CR>

" Decorators
ia <buffer> @s @staticmethod
ia <buffer> @c @classmethod

" Special methods of a class
ia <buffer> INI def __init__(self):
ia <buffer> INIT def __init__(self,):<Left><Left>
ia <buffer> DEL def __del__(self):
ia <buffer> CALL def __call__(self):
ia <buffer> STR def __str__(self):
ia <buffer> DICT def __dict__(self):

" Idioms
ia <buffer> PARSER def make_parser():<CR>
			\usage = '%prog'<CR>
			\parser = OptionParser(usage)<CR>
			\parser.add_option()<CR>
			\#('-e', '--example', dest='e'[, action, default, help])
			\<CR>return parser
ia <buffer> COMMANDS commands = Commands(dict=globals())<CR>
			\commands.use_preset_commands()<CR>
			\commands.call_with_args()

" Mischellaneous
ia <buffer> KW **kwargs<C-R>=Eatspace()<CR>

" Extra
ia <buffer> line@ #<Esc>77a-<Esc><Esc>a
ia <buffer> Line@ #<Esc>77a-<Esc><Esc>^3lR

"-- Ropevim ------------------------------------------------------------------
" RopeCodeAssist() returns '0', so we should avoid it.
function! RopeCodeAssist_()
	RopeCodeAssist
	return ""
endfunction

let ropevim_guess_project=1

