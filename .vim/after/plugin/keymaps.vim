nnoremap <Leader>e :Explore<CR>
nnoremap <Leader>n :new<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>g :G \| only<CR>
vnoremap <Leader>s y/<C-R>"<CR><S-N>cgn

" ThePrimeagen
xnoremap <Leader>p "_dP
" asbjornHaland
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y

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
  nnoremap <Leader>t :call <SID>small_terminal()<CR>
endif

" Make esc leave terminal mode
tnoremap <Leader><Esc> <C-\><C-n>
