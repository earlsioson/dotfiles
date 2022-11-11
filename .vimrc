set number
set relativenumber
set encoding=utf-8
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrap
set mouse=a
set signcolumn=yes
set background=dark
set foldlevel=99
set diffopt+=iwhite
set diffexpr=""
set splitbelow
set listchars=tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·,space:␣
set sessionoptions-=blank

filetype on
filetype plugin on
filetype indent on

syntax on

let mapleader="\<Space>"
let g:VM_leader = '\'
let g:netrw_banner=0
let g:netrw_liststyle = 3
let g:netrw_preview = 1
let g:netrw_bufsettings = 'noma nomod nowrap ro nobl'

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'arcticicestudio/nord-vim'
Plug 'mhinz/vim-startify'
Plug 'justinmk/vim-dirvish'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

let g:go_addtags_transform = 'camelcase'

if has('nvim')
      let g:loaded_python_provider = 0
      let g:python3_host_prog = '/Users/earl/.venv/nvim/bin/python'
      lua require('init')
      if has('termguicolors')
        set termguicolors
        colorscheme tokyonight-night
      else
        colorscheme darkblue
      endif
else
      if has('termguicolors')
        set termguicolors
        colorscheme nord
      else
        colorscheme darkblue
      endif
endif
if has('win32')
  let &shell = 'pwsh'
  let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shellquote= shellxquote=
endif
