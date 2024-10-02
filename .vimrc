" === Plugin Management ===
" Use vim-plug to manage plugins. Plugins are installed in ~/.vim/plugged
call plug#begin('~/.vim/plugged')

" NERDCommenter: A tool for commenting/uncommenting code
Plug 'preservim/nerdcommenter'

" Solarized Color Scheme
Plug 'altercation/vim-colors-solarized'

" CtrlP: Fuzzy file finder
Plug 'ctrlpvim/ctrlp.vim'

" Initialize plugin system
call plug#end()

" === Filetype Detection & Plugin Support ===
" Enable filetype detection, plugins, and indentation rules
filetype on
filetype plugin indent on

" Disable Vi compatibility for better Vim features
set nocompatible

" === Mouse Support ===
" Enable mouse in all modes
set mouse=a

" === Tab and Indentation Settings ===
" Set tab to 2 spaces and use spaces instead of tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Set an exception for Python files, which use 4 spaces for indentation
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Enable auto-indentation
set autoindent
" Set encoding to UTF-8
set encoding=utf-8

" === CTags Integration ===
" Use CTags for source code navigation
set tags=tags;/

" === Display Settings ===
" Keep 3 lines visible above and below the cursor
set scrolloff=3
" Show current mode (insert, normal, etc.)
set showmode
" Display partial commands as they are typed
set showcmd
" Always show the status bar at the bottom
set laststatus=2
" Show line numbers
set number
" Show the cursor position in the status line
set ruler

" === Buffer Management ===
" Allow switching between unsaved buffers
set hidden

" === Command-line Completion ===
" Enhanced command-line completion with visual feedback
set wildmenu
" Show a list of matches and then complete the longest common part
set wildmode=list:longest

" === Cursor Settings ===
" Highlight the current line
set cursorline

" === Performance Settings ===
" Optimize for fast terminals by reducing redraw lag
set ttyfast

" === Backspace Behavior ===
" Allow backspace over indentation, line breaks, and insert points
set backspace=indent,eol,start

" === Leader Key ===
" Set the leader key to ","
let mapleader = ","

" === Searching ===
" Use magic search by default (enables advanced regex features)
nnoremap / /\v
vnoremap / /\v

" Ignore case when searching, unless search pattern contains uppercase
set ignorecase
set smartcase
" Incrementally highlight search results as you type
set incsearch
" Highlight search results
set hlsearch

" Press <leader> + <space> to clear search highlights
nnoremap <leader><space> :noh<cr>

" === Navigation Shortcuts ===
" Jump to matching braces or parentheses with <tab>
nnoremap <tab> %

" === Line Wrapping ===
" Enable line wrapping and set text width to 79 characters
set wrap
set textwidth=79
" Configure wrapping and formatting options
set formatoptions=qrn1

" === Keyboard Shortcuts ===
" Move by display lines (wrapped lines) instead of actual lines
nnoremap j gj 
nnoremap k gk

" Disable <F1> key (to prevent accidental help popup)
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Toggle paste mode with <F2>
set pastetoggle=<F2>

" Use "jj" as a shortcut to exit insert mode
inoremap jj <ESC>

" Auto-save all files when Vim loses focus
au FocusLost * :wa

" === Color Settings ===
" Set background to dark for better contrast in dark themes
set background=dark

" Enable syntax highlighting
syntax on

" Apply the Solarized color scheme
silent! colorscheme solarized

" === Spell Checking ===
" Enable spell check for English (US)
set spelllang=en_us

" === File Navigation ===
" Open a file in the same directory as the current file
if has("unix")
    map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
else
    map <leader>e :e <C-R>=expand("%:p:h") . "\" <CR>
endif

" === Ctrl-P Configuration ===
" Set Ctrl-P shortcut for fuzzy file finder
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Search files recursively, starting from the root directory
let g:ctrlp_working_path_mode = 'ra'

" === Custom File Copy Shortcut ===
" Shortcut to copy current file to its directory
if has("unix")
    map <leader>y :!cp <C-R>=expand("%") <CR> <C-R>=expand("%:p:h") . "/" <CR>
else
    map <leader>y :!cp <C-R>=expand("%") <CR> <C-R>=expand("%:p:h") . "\" <CR>
endif

" === iTerm2 Solarized Patch ===
" Workaround for Solarized color issues in iTerm2
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

" === Local Config Support ===
" Source additional settings from ~/.local.vimrc if it exists
if filereadable($HOME . '/.local.vimrc')
    source ~/.local.vimrc
endif
