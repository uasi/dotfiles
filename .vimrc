"-- Plugs {{{ ----------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'MattesGroeger/vim-bookmarks' " |vim_bookmarks|
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite.vim' " |unite_vim|
Plug 'Yggdroot/indentLine' " |indentline|
Plug 'airblade/vim-gitgutter' " |vim_gitgutter|
Plug 'bkad/CamelCaseMotion' " |camelcasemotion|
Plug 'easymotion/vim-easymotion' " |vim_easymotion|
Plug 'elzr/vim-json' " |vim_json|
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'rhysd/committia.vim'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'slack/vim-l9'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors' " |vim_multiple_cursors|
Plug 'thinca/vim-localrc'
Plug 'thinca/vim-quickrun' " |vim_quickrun|
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive' " |vim_fugitive|
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'ujihisa/shadow.vim'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/sudo.vim'

if has('python3')
  Plug 'Shougo/deoplete.nvim' " |deoplete_nvim|
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'digitaltoad/vim-jade', {'for': 'jade'}
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'slim-template/vim-slim', {'for': 'slim'}

call plug#end()

" See ~/.vim/plugin/pluged/*.vim for settings of plugins.
" See ~/.vim/etc/unused_settings.vim for unused plugins.

" To create/remove empty setting file for each plugin,
" call `plug_helper#stub()` / `plug_helper#unstub()`.

"-- Plugs }}} ----------------------------------------------------------------
"-- Vim settings {{{ ---------------------------------------------------------

" Suppress deprecation warning from Python 3.7.
" See https://github.com/vim/vim/issues/3117#issuecomment-402622616
if has('python3')
  silent! python3 pass
endif

set tags+=~/.vimrc.tags

set encoding=utf-8
set ignorecase
set smartcase  " Case-sensitive search when query includes uppercase character.
set laststatus=2  " Always show status-line.
set statusline=%y%{GetStatusEx()}\ %f%m%r%=<%c:%l/%L>
set foldmethod=marker
set backspace=indent,eol,start
set synmaxcol=256  " Limit maximum column upto witch Vim tries to parse syntax.

set mouse=a

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

au BufWritePost .vimrc :exec 'silent ! ~/.vim/bin/generate_vimrc_tags.pl'

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
