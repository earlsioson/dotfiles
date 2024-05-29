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
set splitright
set listchars=tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·,space:␣
set sessionoptions-=blank

filetype on
filetype plugin on
filetype indent on

syntax on

let mapleader="\<Space>"
let g:VM_leader = '\'
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_bufsettings='noma nomod nobl nowrap ro rnu'

if has('nvim')
  let g:loaded_python_provider = 0
  let g:python3_host_prog = expand('~/.venv/nvim/bin/python')

  lua require('init')
  if has('termguicolors')
    set termguicolors
    colorscheme tokyonight-night
  else
    colorscheme darkblue
  endif
else
  call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'arcticicestudio/nord-vim'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'github/copilot.vim'
  Plug 'terrastruct/d2-vim'
  call plug#end()

  let g:go_addtags_transform = 'camelcase'

  if has('termguicolors')
    set termguicolors
    colorscheme nord
  else
    colorscheme darkblue
  endif
endif

nnoremap <Leader>e :Explore<CR>
nnoremap <Leader>n :new<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>g :G \| only<CR>
vnoremap <Leader>s y/<C-R>"<CR><S-N>cgn
nnoremap <Leader>a :b#<CR>
nnoremap <Leader>cd :lcd %:h<CR>
nnoremap <Leader>k :let @/ = ""<CR>
nnoremap <M-.> <C-w>5>
nnoremap <M-,> <C-w>5<
nnoremap <M-'> <C-w>+
nnoremap <M-;> <C-w>-

" ThePrimeagen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" asbjornHaland
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y

function! Tabline() abort
  let l:line = ''
  let l:current = tabpagenr()

  for l:i in range(1, tabpagenr('$'))
    if l:i == l:current
      let l:line .= '%#TabLineSel#'
    else
      let l:line .= '%#TabLine#'
    endif

    let l:label = fnamemodify(
          \ bufname(tabpagebuflist(l:i)[tabpagewinnr(l:i) - 1]),
          \ ':t'
          \ )

    let l:line .= '%' . i . 'T' " Starts mouse click target region.
    let l:line .= ' '. (i) . ' '
    let l:line .= '  ' . l:label . '  '
  endfor

  let l:line .= '%#TabLineFill#'
  let l:line .= '%T' " Ends mouse click target region(s).

  return l:line
endfunction

set tabline=%!Tabline()

" tjdevries
if has('nvim')
  function! s:small_terminal() abort
    new
    wincmd J
    call nvim_win_set_height(0, 12)
    set winfixheight
    term
  endfunction

  " ANKI: Make a small terminal at the bottom of the screen.
  nnoremap <Leader><Leader>t :call <SID>small_terminal()<CR>
endif

" Make esc leave terminal mode
tnoremap <Leader><Esc> <C-\><C-n>

set autowrite
