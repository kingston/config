" Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
Bundle 'gmarik/vundle'

Bundle 'tpope/vim-rails'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'ervandew/supertab'
Bundle 'AutoComplPop'

Bundle 'Lokaltog/vim-easymotion'

Bundle 'altercation/vim-colors-solarized'

Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'

Bundle 'kchmck/vim-coffee-script'

Bundle 'rodjek/vim-puppet'

Bundle 'nono/vim-handlebars'

if version >= 703
  Bundle 'git://git.wincent.com/command-t.git'
  Bundle 'sjbach/lusty'
endif

" Filetype Configuration
filetype on
filetype plugin indent on

set nocompatible

" Mouse Configuration
set mouse=a

" Tab Configuration
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Set exception for ruby which has 2 spaces
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

set autoindent
set encoding=utf-8

" CTags
set tags=tags;/

" Display stuff
" Sets how much to show above and below the cursor
set scrolloff=3
set showmode
set showcmd
set laststatus=2 "Always show status bar at the bottom
set number "Show line number
set ruler

" Hidden buffers or something complicated
set hidden
" Bash-like autocompletions
set wildmenu
set wildmode=list:longest

" Put a nice line at thr cursor
set cursorline

" Something about optimizing for fast terminals
set ttyfast

" Backspace behavior
set backspace=indent,eol,start

" Mapping stuff
let mapleader = ","

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set hlsearch
" Type ", " to remove highlighting
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
nnoremap <tab> %

" EasyMotion
let g:EasyMotion_leader_key = 'q'

" Wrapping
set wrap
set textwidth=79
set formatoptions=qrn1

" Keyboard shortcuts
" Make j go to next displayed line
nnoremap j gj 
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap ; :

set pastetoggle=<F2>

" Use "jj" instead of pressing <ESC>
inoremap jj <ESC>

" Auto-save upon lose focus
au FocusLost * :wa

" I apparently like dark backgrounds
set background=dark

" Color syntax highlighting
syntax on

" Solarized palette
silent! colorscheme solarized

" Programming helpful stuff
runtime ftplugin/man.vim

" Spell checking
set spelllang=en_us

" NERDTree Bindings
map <F2> :NERDTreeToggle<CR>

" bind "gb" to "git blame" for visual and normal mode.
vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
nmap gb :Gblame<CR>
nmap gl :Glog<CR>
nmap gd :Gdiff<CR>

" CD into current directory - we'll see how well this works...
"   Edit another file in the same directory as the current file
"   uses expression to extract path from current file's path
"  (thanks Douglas Potts)
if has("unix")
    map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
else
    map <leader>e :e <C-R>=expand("%:p:h") . "\" <CR>
endif

" CD into current directory

if has("unix")
    map <leader>y :!cp <C-R>=expand("%") <CR> <C-R>=expand("%:p:h") . "/" <CR>
else
    map <leader>y :!cp <C-R>=expand("%") <CR> <C-R>=expand("%:p:h") . "\" <CR>
endif

" Source local settings
if filereadable($HOME . '/.local.vimrc')
    source ~/.local.vimrc
endif

