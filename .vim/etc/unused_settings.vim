"-- Plugins and Related Settings {{{ -----------------------------------------

" Clever F
NeoBundle 'rhysd/clever-f.vim'

" Unite and Unite plugins
NeoBundle 'unite-yarm'
NeoBundle 'unite-gem'
NeoBundle 'unite-locate'
NeoBundle 'unite-font'
NeoBundle 'unite-colorscheme'

" Indent guides
NeoBundle 'nathanaelkane/vim-indent-guides'
colorscheme default
let g:indent_guides_auto_colors = 0
let g:indent_guides_default_mapping = 0
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 1
au VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
au VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236

" Perl syntax etc
NeoBundle 'petdance/vim-perl'

" CoffeeScript syntax
NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload': {'filetypes': ['coffee']}}
let g:coffee_no_trailing_space_error = 1

" Rake
NeoBundle 'tpope/vim-rake'

" Fugitive. Control Git from within Vim
NeoBundle 'tpope/vim-fugitive'

" SLIMV - Superior Lisp Interaction Mode for Vim
NeoBundleLazy 'slimv.vim', {'autoload': {'filetypes': ['clojure']}}
let g:slimv_leader = '<LocalLeader>'
let g:paredit_leader = '<LocalLeader>'

" Javascript syntax
NeoBundleLazy 'drslump/vim-syntax-js', {'autoload': {'filetypes': ['javascript']}}
let g:syntax_js = ['function', 'this', 'return']

" Jade, a JavaScript template language
NeoBundleLazy 'digitaltoad/vim-jade', {'autoload': {'filetypes': ['jade']}}
autocmd BufNewFile,BufReadPost *.jade set filetype=jade

" The Slim template language
NeoBundleLazy 'slim-template/vim-slim', {'autoload': {'filetypes': ['slim']}}
autocmd BufNewFile,BufReadPost *.slim set filetype=slim

" Syntastic
Plug 'scrooloose/syntastic' " |syntastic| |syntastic_autocmd|

" Directory-local vimrc
Plug 'thinca/vim-localrc'

" Rails
Plug 'tpope/vim-rails'

" Multi cursors
Plug 'mg979/vim-visual-multi'

"-- Plugins and Related Settings }}} -----------------------------------------

"-- Other Settings {{{ -------------------------------------------------------

" SKK Jisyo
let skk_jisyo = $HOME . "/Library/Application\ Support/AquaSKK/.skk-jisyo.utf8"
let skk_large_jisyo = $HOME . "/Library/Application\ Support/AquaSKK/SKK-JISYO.L"
let skk_auto_save_jisyo = 1
let skk_keep_state = 1
let skk_egg_like_newline = 1
let skk_marker_white = "[]"
let skk_marker_black = "[#]"

" Autocake
au BufReadPost *.coffee call autocake#enable()

" Set UTF-8 flag
au BufWritePost * call SetUTF8Xattr(expand("<afile>"))

"-- Other Settings }}} -------------------------------------------------------

"-- Functions {{{ ------------------------------------------------------------

" Fire omni-completion with tab.
" Need for fix: unwanted completion fire some times.
" Yanked from http://jigen.aruko.net/2006/11/29/method-to-carry-out-omni-supplement-in-tab-in-vim7/
" To enable, put below in ftplugin.
"inoremap <tab> <c-r>=BeginOmniComplWithTab()<cr>
function! BeginOmniComplWithTab()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    "if !col || getline('.')[col - 1] !~ '\k\|<\|/\'
    if !col || getline('.')[col - 1] !~ '\k\|<\|/\|.'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction

function! SetUTF8Xattr(file)
	let isutf8 = &fileencoding == "utf-8" || ( &fileencoding == "" && &encoding == "utf-8")
	if has("unix") && match(system("uname"),'Darwin') != -1 && isutf8
		call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' '" . a:file . "'")
	endif
endfunction

"-- Functions }}} ------------------------------------------------------------
