set nu
set relativenumber
set encoding=utf-8
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set hidden
set nowrap
set mouse=a
set scrolloff=8
set signcolumn=yes
filetype on
filetype plugin on
filetype indent on
syntax on
let mapleader="\<Space>"
let g:VM_leader = '\'
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
call plug#end()

set background=dark
colorscheme nord
let g:airline_theme='nord'
if has('nvim')
      let g:loaded_python_provider = 0
      let g:python3_host_prog = '/Users/earl/.venv/nvim/bin/python'
      lua require('init')
endif
if has('win32')
  set termguicolors
  let &shell = 'pwsh'
  let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shellquote= shellxquote=
endif
