set encoding=utf-8
set tabstop=2
set shiftwidth=2
set expandtab
set mouse=a
set autochdir
set laststatus=2
set smartcase
set nocompatible
set backspace=indent,eol,start
set completeopt-=preview
set background=dark
color default
filetype on
filetype plugin on
filetype indent on
syntax on
let python_highlight_all=1
let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')
Plug 'chiel92/vim-autoformat'
Plug 'nvie/vim-flake8'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tomtom/tcomment_vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'hlissner/vim-multiedit'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
call plug#end()
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

autocmd BufNewFile,BufRead *.scss set ft=scss.css
autocmd BufNewFile,BufRead *.sass set ft=sass.css
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead *.swift setlocal filetype=swift
autocmd FileType markdown,md setlocal spell spelllang=en
autocmd FileType yaml,yml setl indentkeys-=<:>
autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html,css,js EmmetInstall
au BufNewFile,BufRead *.py
      \ set tabstop=4 |
      \ set softtabstop=4 |
      \ set shiftwidth=4 |
      \ set textwidth=79 |
      \ set expandtab |
      \ set noautoindent |
      \ set smartindent |
      \ set fileformat=unix

let g:go_addtags_transform = 'camelcase'

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'javascript': ['prettier', 'eslint'],
      \   'css': ['prettier'],
      \}
let g:ale_fix_on_save = 1
set formatoptions-=t
let g:netrw_liststyle = 3
let g:netrw_banner = 0
