" Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
Bundle 'gmarik/vundle'

Bundle 'tpope/vim-rails'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'vim-scripts/JavaScript-Indent'
Bundle 'scrooloose/nerdcommenter'
Bundle 'ervandew/supertab'
Bundle 'AutoComplPop'

Bundle 'Lokaltog/vim-easymotion'

Bundle 'altercation/vim-colors-solarized'

Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'sjbach/lusty'

" Filetype Configuration
filetype on
filetype plugin indent on

set nocompatible

" Mouse Configuration
set mouse=a

" Tab Configuration
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set autoindent
set encoding=utf-8

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
colorscheme solarized

" Programming helpful stuff
runtime ftplugin/man.vim

" Spell checking
set spelllang=en_us

" NERDTree Bindings
map <F2> :NERDTreeToggle<CR>

" Source local settings
if filereadable($HOME . '/.local.vimrc')
    source ~/.local.vimrc
endif

