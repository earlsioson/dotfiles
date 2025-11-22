" Shared settings + keymaps for Vim and Neovim.
if exists("g:loaded_es_common")
  finish
endif
let g:loaded_es_common = 1

" Core options
set number
set relativenumber
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrap
set mouse=a
set signcolumn=yes
set background=dark
set foldlevelstart=99
set foldcolumn=1
set splitbelow
set splitright
set listchars=tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,trail:·,space:␣
set autowrite
set diffopt+=iwhite
set completeopt=menu,menuone,noselect

" Search behavior
set ignorecase
set smartcase
set nohlsearch
set incsearch

" Scrolling behavior
set scrolloff=8
set sidescrolloff=8

" Backspace behavior
set backspace=indent,eol,start

" Cursor line highlighting
set cursorline

if has('termguicolors')
  set termguicolors
endif

filetype on
filetype plugin on
filetype indent on

syntax on

" Shared globals
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_bufsettings = 'noma nomod nobl nowrap ro rnu'
let g:markdown_folding = 1
let g:markdown_enable_folding = 1
let g:go_addtags_transform = 'camelcase'

" Helpers
function! s:small_terminal() abort
  if has('nvim')
    new
    wincmd J
    call nvim_win_set_height(0, 12)
    set winfixheight
    term
  elseif exists(':terminal')
    botright 12split
    setlocal winfixheight
    terminal
  endif
endfunction

function! s:change_dir_to_buffer() abort
  let l:dir = expand('%:p:h')
  if !empty(l:dir)
    execute 'lcd ' . fnameescape(l:dir)
  endif
endfunction

" Keymaps
" Note: <Leader>cd, <Leader>t, and <Leader>g removed to avoid conflicts with Neovim keymaps
nnoremap <Leader>n :new<CR>
vnoremap <Leader>r y/<C-R>"<CR><S-N>cgn
nnoremap <Leader>a :b#<CR>
nnoremap <Leader>k :let @/ = ""<CR>
nnoremap <M-.> <C-w>5>
nnoremap <M-,> <C-w>5<
nnoremap <M-'> <C-w>+
nnoremap <M-;> <C-w>-
nnoremap z0 :set foldlevel=99<CR>
nnoremap z1 :set foldlevel=1<CR>
nnoremap z2 :set foldlevel=2<CR>
nnoremap z3 :set foldlevel=3<CR>
nnoremap z4 :set foldlevel=4<CR>
nnoremap z5 :set foldlevel=5<CR>
nnoremap z6 :set foldlevel=6<CR>
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <silent> <Leader><Leader>t :call <SID>small_terminal()<CR>

if has('terminal')
  tnoremap <Leader><Esc> <C-\><C-n>
endif

" Filetype-specific tweaks
augroup es_shared_ft
  autocmd!
augroup END

" Vim-specific folding
if !has('nvim')
  set foldmethod=syntax
  augroup es_shared_ft_fold
    autocmd!
    autocmd FileType javascript,javascriptreact,lua,python setlocal foldmethod=indent
    autocmd FileType go,rust,c,typescript,typescriptreact setlocal foldmethod=syntax
  augroup END
endif
