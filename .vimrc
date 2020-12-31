set nu
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
filetype on
filetype plugin on
filetype indent on
syntax on
let python_highlight_all=1
let mapleader="\<Space>"
let g:VM_leader = '\'
call plug#begin('~/.vim/plugged')
Plug 'chiel92/vim-autoformat'
Plug 'nvie/vim-flake8'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tomtom/tcomment_vim'
Plug 'mg979/vim-visual-multi'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'fatih/vim-hclfmt', { 'do': 'go get github.com/fatih/hclfmt' }
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'SirVer/ultisnips'
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

set autowrite

let g:go_addtags_transform = 'camelcase'
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'javascript': ['eslint'],
      \   'typescript': ['eslint'],
      \   'css': ['prettier'],
      \}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#enabled = 1

set formatoptions-=t
let g:netrw_liststyle = 3
let g:netrw_banner = 0
set background=dark
colorscheme nord
let g:airline_theme='nord'
let g:airline_powerline_fonts = 1
if (has("termguicolors"))
      set termguicolors
endif
if has('nvim')
      let g:loaded_python_provider = 0
      let g:python3_host_prog = '/Users/earl/dev/envs/py3/bin/python3'
endif
