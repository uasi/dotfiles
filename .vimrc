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
Plug 'terryma/vim-expand-region' " |vim_expand_region|
Plug 'terryma/vim-multiple-cursors' " |vim_multiple_cursors|
Plug 'thinca/vim-quickrun' " |vim_quickrun|
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive' " |vim_fugitive|
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
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

" Remap gf to open a plug in the browser.
function! PlugOpen()
  exec 'silent ! open https://github.com/' . expand('<cfile>')
  call feedkeys("\<C-l>") " Refresh screen wiped by the command above.
endfunction
au BufEnter .vimrc nmap <buffer> <silent> gf :call PlugOpen()<CR>

"-- Plugs }}} ----------------------------------------------------------------
"-- Vim settings {{{ ---------------------------------------------------------

" Suppress deprecation warning from Python 3.7.
" See https://github.com/vim/vim/issues/3117#issuecomment-402622616
if has('python3')
  silent! python3 pass
endif

set encoding=utf-8 " Set default encoding. Otherwise it would be latin1.
set ignorecase " Ignore case in the search pattern.
set smartcase " Override ignorecase if the search pattern contains uppercase characters.
set laststatus=2 " Always show status-line.
set foldmethod=marker " Automatically fold by markers.
set backspace=indent,eol,start " Allow backspacing over these items.
set synmaxcol=256 " Limit maximum column upto witch Vim tries to parse syntax.
set number " Show line number.
set mouse=a " Enable mouse for *a*ll modes.
set visualbell t_vb= " Silence beep sound.
set hidden " Hide buffer when it is abonedoned.
set scrolloff=2 " Set minimum number of lines to keep visible around the cursor.

" Enable incremental search with highlight.
set hlsearch
set incsearch

" Enhance command-line completion.
set wildmenu
set wildmode=longest,full

" Show tabs and trailing whitespaces.
set list
set listchars=tab:>-,trail:_

" Set position of a new split window.
set splitbelow
set splitright

" Make wrapped line continue visually indented.
set breakindent
let &breakindentopt = 'sbr'
let &showbreak = '> '

" Set local leader character.
let maplocalleader = '_'

" Extend '%' motion.
packadd matchit

" Prepare my data directory.
let $VIM_DATA_DIR = $HOME . '/.local/share/vim'
if !isdirectory($VIM_DATA_DIR)
  call mkdir($VIM_DATA_DIR, 'p')
endif

" Add a tags file to jump around my vim settings.
set tags+=$VIM_DATA_DIR/vimrc_tags

" Enable backup.
set backup
set backupdir=$VIM_DATA_DIR/backup
if !isdirectory(&backupdir)
  call mkdir(&backupdir)
endif

" Set swapfile directory.
set directory=$VIM_DATA_DIR/swap
if !isdirectory(&directory)
  call mkdir(&directory)
endif

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
nnoremap <silent> <Esc><Esc> :noh<CR><Esc>

" Insert current file's path and it's base directory, respectively
cnoremap <C-X> <c-r>=expand('%:p:h')<cr>/
cnoremap <C-Z> <c-r>=expand('%:p:r')<cr>

" Map omni-completion to Ctrl-B which is unused
inoremap <C-B> <C-X><C-O>

" Search selected string by * in visual mode
" Yanked from http://labs.timedia.co.jp/2014/09/learn-about-vim-in-the-workplace.html
vnoremap * "zy:let @/ = @z<CR>n

" Miscellany
cnoremap w!! w !sudo tee > /dev/null %
inoremap <C-J> <Esc>o
noremap Y y$

"-- Mappings }}} -------------------------------------------------------------
"-- Abbereviations {{{ -------------------------------------------------------

" Correct common typos.
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
