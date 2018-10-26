"-- Bundles {{{ --------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'MattesGroeger/vim-bookmarks' " |vim_bookmarks|
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite.vim' " |unite_vim|
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter' " |vim_gitgutter|
Plug 'easymotion/vim-easymotion' " |vim_easymotion|
Plug 'elixir-lang/vim-elixir'
Plug 'elzr/vim-json' " |vim_json|
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'rhysd/committia.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic' " |syntastic| |syntastic_autocmd|
Plug 'sheerun/vim-polyglot'
Plug 'slack/vim-l9'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors' " |vim_multiple_cursors|
Plug 'thinca/vim-localrc'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-unimpaired'
Plug 'ujihisa/shadow.vim'
Plug 'vim-scripts/sudo.vim'

if has('python3')
  Plug 'Shougo/deoplete.nvim' " |deoplete|
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'digitaltoad/vim-jade', {'for': 'jade'}
Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'slim-template/vim-slim', {'for': 'slim'}

call plug#end()

" See $DOTVIM/etc/unused_settings.vim for unused plugins.

"-- Bundles }}} --------------------------------------------------------------
"-- Vim settings {{{ ---------------------------------------------------------

" Suppress deprecation warning from Python 3.7.
" See https://github.com/vim/vim/issues/3117#issuecomment-402622616
if has('python3')
  silent! python3 pass
endif

" Get the appropriate 'dot vim' directory
let g:dotvim = $HOME . '/.vim'
if strlen(glob(g:dotvim)) == 0
  let g:dotvim = $HOME . '/vimfiles'
endif
let $DOTVIM = g:dotvim

set tags+=~/.vimrc.tags

set encoding=utf-8
set ignorecase
set smartcase  " Case-sensitive search when query includes uppercase character.
set laststatus=2  " Always show status-line.
set statusline=%y%{GetStatusEx()}\ %f%m%r%=<%c:%l/%L>
set foldmethod=marker
set backspace=indent,eol,start
set synmaxcol=256  " Limit maximum column upto witch Vim tries to parse syntax.

set wildmode=longest,full
set wildmenu

set listchars=tab:>-,trail:_
set list

set visualbell t_vb=

set backup
set backupdir=$HOME/.vimbackup
if !isdirectory(&backupdir)
        call mkdir(&backupdir)
endif

let &directory = &backupdir

" Make splitting a window put the new window bottom below and right of the
" current one
set splitbelow
set splitright

" Make a buffer become hidden when it is abonedoned
set hidden

" Set minimal number of screen lines to keep above and below the cursor
set scrolloff=2

" Enable syntax and filetype plugin
syntax on
filetype plugin on
filetype indent on

if v:version >= 703
  " Show the line number relative to the cursor line
  set relativenumber
endif

if v:version >= 800
  " Make wrapped line continue visually indented
  set breakindent
  let &breakindentopt = 'sbr'
  let &showbreak = '> '
endif

" MacVim specific options
if has('gui_macvim')
  set imdisable " Avoid icon duplication
endif

let maplocalleader = "_"

"-- Vim settings }}} ---------------------------------------------------------
"-- Plugin settings {{{ ------------------------------------------------------

if has('python3')
  " *deoplete*
  source $DOTVIM/rc/deoplete_config.vim
endif

" Unite configuration *unite_vim*
let g:unite_enable_start_insert=1

" QuickRun configuration *quickrun*
let g:quickrun_config = {}
let g:quickrun_config['bin/run'] = {'exec': 'run'}

" ChangeLog congiguration
let g:changelog_username=$NAME . "  <" . $EMAIL . ">"
highlight changelogNumber ctermfg=Black
highlight changelogDay ctermfg=Black
highlight changelogMonth ctermfg=Black

" Disable EnhancedCommentify in insert mode
let g:EnhCommentifyBindInInsert = 'no'

" Rust syntax settings
let g:no_rust_conceal = 1
let g:rust_conceal_mod_path = 1
let g:rust_conceal_pub = 1

" *vim_multiple_cursors*
let g:multi_cursor_next_key = '<C-@>'

" *indentLine*
let g:indentLine_char = "\u2847" " BRAILLE PATTERN DOTS-1237
let g:indentLine_color_term = 235

" *vim_json*
let g:vim_json_syntax_conceal = 0

" *vim_bookmarks*
let g:bookmark_save_per_working_dir = 1

" *vim_gitgutter*
let g:gitgutter_sign_added = '·'

" Not installed:
"let g:syntastic_scss_checkers = ['scss_lint']
"let g:syntastic_coffee_checkers = ['coffeelint']
let g:syntastic_typescript_checkers = []


"-- Plugin settings }}} ------------------------------------------------------
"-- Mappings {{{ -------------------------------------------------------------

""" Extended moves
" First/last changed/yanked
nnoremap Ki '[
nnoremap Ji ']
" First/last selected
nnoremap Kv '<
nnoremap Jv '>

" Move around windows and tabs
nnoremap T :tab
nnoremap <silent> <Right> :tabnext<CR>
nnoremap <silent> <Left> :tabprevious<CR>
nnoremap <silent> <Tab> :<C-U>wincmd w<CR>
nnoremap <silent> <S-Tab> :<C-U>wincmd W<CR>

" Emacs-like motion in command mode
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

" Unhilight search results by double-tapping <Esc>
" Yanked from http://d.hatena.ne.jp/viver/20070612/p1
set hlsearch
nnoremap <silent> <Esc><Esc> :noh<CR><Esc>

" Insert current file's path and it's base directory, respectively
cnoremap <C-X> <c-r>=expand('%:p:h')<cr>/
cnoremap <C-Z> <c-r>=expand('%:p:r')<cr>

" Map omni-completion to Ctrl-B which is unused
inoremap <C-B> <C-X><C-O>

" Search selected string by * in visual mode
" Yanked from http://labs.timedia.co.jp/2014/09/learn-about-vim-in-the-workplace.html
vnoremap * "zy:let @/ = @z<CR>n

" Camelcase-sensitive motion
noremap <silent> <Leader>b b
noremap <silent> <Leader>e e
noremap <silent> <Leader>w w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> w <Plug>CamelCaseMotion_w

if !has('lua')
  " For neocomplcache (yanked from its manual)
  imap <C-l> <Plug>(neocomplcache_snippets_expand)
  smap <C-l> <Plug>(neocomplcache_snippets_expand)
  inoremap <expr><C-g> neocomplcache#undo_completion()
  inoremap <expr><C-b> neocomplcache#complete_common_string()
  " <CR>: close popup and save indent
  " ... doesn't work if neocomplcache is disabled
  " inoremap <expr><CR>  (pumvisible() ? "\<C-y>":'') . "\<C-f>\<CR>X\<BS>"
  " <TAB>: completion
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char
  inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
end

" Miscellany
cnoremap w!! w !sudo tee > /dev/null %
inoremap <C-J> <Esc>o
noremap Y y$

" Unite
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

" FZF
nnoremap <silent> <Space>o :<C-u>FZF<CR>

" Fugitive
nnoremap <silent> <Leader>bl :<C-u>Gblame<CR>
nnoremap <Leader>gg :<C-u>Ggrep<Space>
nnoremap <silent> <Leader>st :<C-u>Gstatus<CR>
function! s:FugitiveMappings()
  if expand('%') == '.git/index'
    nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
  endif
endfunction
au FileType gitcommit call s:FugitiveMappings()

" Quickrun
au FileType quickrun nnoremap <silent> <buffer> <ESC><ESC> :q<CR>

" EasyMotion *vim_easymotion*
nmap s <Plug>(easymotion-jumptoanywhere)

"-- Mappings }}} -------------------------------------------------------------
"-- Abbereviations {{{ -------------------------------------------------------

" For correction
iab erorr error
iab imoprt import
iab improt import
iab labmda lambda
iab retrn return
iab retunr return
iab reqiure require
iab slef self

"-- Abbreviations }}} --------------------------------------------------------
"-- Autocmds {{{ -------------------------------------------------------------

" Set group for the following autocmds
augroup vimrc

" Unregister autocmds in the vimrc group first so that the following autocmds
" will not be registered twice when reloading .vimrc
autocmd!

" Filetype
au BufNewFile,BufRead {Podfile,*.podspec} set filetype=ruby

au BufWritePost .vimrc :exec 'silent ! ' . g:dotvim . '/bin/generate_vimrc_tags.pl'

au BufReadPost * call s:DetectBufLocalQuickRunType()

" Automatically open QuickFix window
au QuickfixCmdPost make,grep,grepadd,vimgrep cwindow

" End the vimrc group
augroup END

"-- Autocmds }}} -------------------------------------------------------------
"-- Commands {{{ -------------------------------------------------------------

command -nargs=* -complete=file New tabnew

"-- Commands }}} -------------------------------------------------------------
"-- Highlight {{{ ------------------------------------------------------------

hi Folded ctermbg=NONE
hi LineNr ctermfg=darkgray

" Highlight TabLine
" Stolen from http://d.hatena.ne.jp/teramako/20070318/vim7_tab
hi TabLine     term=reverse cterm=reverse,underline ctermfg=white ctermbg=blue
hi TabLineSel  term=bold cterm=bold ctermfg=5
hi TabLineFill term=reverse cterm=reverse,underline ctermfg=white ctermbg=blue

"-- Highlight }}}-------------------------------------------------------------
"-- Functions {{{ ------------------------------------------------------------

" Delete a character under the cursor if char == pat
" Yanked from http://www.ac.cyberhome.ne.jp/~yakahaira/vimdoc/map.html#abbreviations
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction

" Delete a space character under the cursor
" Usage:
"    iab <silent> if if()<Left><C-R>=Eatspace()<CR>
function! Eatspace()
  return Eatchar('\s')
endfunction

" Get encoding and newline type
function! GetStatusEx()
  let str = ''
  let str = str . '' . &fileformat . ']'
  if has('multi_byte') && &fileencoding != ''
    let str = '[' . &fileencoding . ':' . str
  elseif &fileencoding == '' && &encoding != ''
    let str = '[' . &encoding . ':' . str
  else
    let str = '[' . 'enc?' . ':' . str
  endif
  return str
endfunction

" Decide bookmarks file location.
" If the current directory is under a git's work tree, place bookmarks file at
" the root of the work tree. Otherwise place at ~/.
" *vim_bookmarks*
function! g:BMWorkDirFileLocation()
  let filename = '.vim_bookmarks'
  let gitdir = finddir('.git', '.;')
  if len(gitdir) > 0
    let location = fnamemodify(gitdir, ':p:h:h')
  else
    let location = $HOME
  end
  return location . '/' . filename
endfunction

" Detect buffer local QuickRun type.
" If the last line of the current file contains `quickrun_type = *`,
" this function sets buffer local QuickRun type to the specified type.
function! s:DetectBufLocalQuickRunType()
  let line = getline('$')
  let m = matchlist(line, 'quickrun_type *= *\([^ ]\+\)')
  if len(m) > 0
    let type = m[1]
    let b:quickrun_config = {'type': type}
  end
endfunction

"-- Functions }}} ------------------------------------------------------------
"-- Miscellany {{{ -----------------------------------------------------------

" Extend '%' functionality.
" Say, we can jump between if-fi, begin-end, etc.
" See http://nanasi.jp/articles/vim/matchit_vim.html.
"
" To add a pair, do :let b:match_pairs = "(:),<if>:<fi>" or the like.
"
source $VIMRUNTIME/macros/matchit.vim

"-- Miscellany }}} -----------------------------------------------------------
