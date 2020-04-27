"*****************************************************************************
"" Install Vim-Plug if not exists
"*****************************************************************************
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

  autocmd VimEnter * PlugInstall
endif

"*****************************************************************************
"" Plug install packages
"*****************************************************************************

call plug#begin(expand('~/.config/nvim/plugged'))

"" File tree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

"" Git file info
Plug 'airblade/vim-gitgutter'
"" Surround helper
Plug 'tpope/vim-surround'
"" fuzzy search
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

"" Commenting out code
Plug 'tpope/vim-commentary'

"" Session in Vim
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

"" Subword deletion
Plug 'vim-scripts/eraseSubword'

"" Show me the buffers!
Plug 'bling/vim-bufferline'

"" Theme
Plug  'arzg/vim-colors-xcode'

"" Relative line
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"" Ident
Plug 'tpope/vim-sleuth'

" Vim-Plug
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" For async completion
Plug 'Shougo/deoplete.nvim'
" For Denite features
Plug 'Shougo/denite.nvim'
Plug 'deoplete-plugins/deoplete-jedi'


" Enable deoplete at startup

  let g:deoplete#enable_at_startup = 1


call plug#end()

"" TMP
let g:deoplete#enable_at_startup = 1


"*****************************************************************************
"" Theme
"*****************************************************************************

colorscheme xcodedark

"*****************************************************************************
"" Key Mappings
"*****************************************************************************

" Map leader to space
let mapleader=' '

" All things session
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" All things buffer
noremap <leader>bp :bp<CR>
noremap <leader>bn :bn<CR>
noremap <leader>bd :bp<cr>:bd #<CR>

"" All things window
nnoremap <leader>wj <C-W>j
nnoremap <leader>wk <C-W>k
nnoremap <leader>wl <C-W>l
nnoremap <leader>wh <C-W>h
nnoremap <leader>wd <C-W>q
nnoremap <leader>w- :split<CR>
nnoremap <leader>w_ :vsplit<CR>

" Subword delete
let g:EraseSubword_insertMap = "<M-Backspace>"

" Escape to clean highlights
nnoremap <silent> <esc> <esc>:noh<return><esc>

" Copy all
nnoremap <space>ac :%y+<CR>

" Redo with U instead of Ctrl-R
noremap U <C-R>

"*****************************************************************************
"" FZF Settings
"*****************************************************************************

"" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'enter'

"" Ctrl+p for fuzzy finder ala sublime
noremap <C-p> :FZF<CR>
"" Ctrl+r for file structure ala sublime TODO
" noremap <C-r> :FZF<CR>
"" Ctrl+m for marks
noremap <C-m> :Marks<CR>
" Commands with Alt-p
noremap <M-p> :Commands<CR>


"*****************************************************************************
"" Abbreviations
"*****************************************************************************

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall


"*****************************************************************************
"" Generic Settings
"*****************************************************************************

" Copy to system clipboard by default
set clipboard=unnamed,unnamedplus


" Better search defaults
set hlsearch
set incsearch
set ignorecase
set smartcase

set shiftwidth=2
set autoindent
set smartindent

" Shell
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif


" Session Management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"
let g:session_command_aliases = 1

" Enable hidden buffers
set hidden

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

" Enable syntax highlighting by default
syntax on
" Enable line number by default - and relative specifically
set number relativenumber

"*****************************************************************************
"" Plugin Configurations
"*****************************************************************************

" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> <M-1> :NERDTreeToggle<CR>
nnoremap <silent> <C-S-L> :NERDTreeToggle<CR>


"*****************************************************************************
"" Commands
"*****************************************************************************

" remove trailing whitespaces
command! RemoveTrailingWhitespaces :%s/\s\+$//e

