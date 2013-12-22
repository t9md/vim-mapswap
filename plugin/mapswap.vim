"=============================================================================
" File: mapswap.vim
" Author: t9md <taqumd@gmail.com>
" WebPage: http://github.com/t9md/vim-mapswap
" License: ?
" Version: 0.0000001
"=============================================================================
" GUARD: {{{
if expand("%:p") ==# expand("<sfile>:p")
  unlet! g:loaded_mapswap
endif
if !exists('g:mapswap_debug')
  let g:mapswap_debug = 0
endif

if exists('g:loaded_mapswap')
  finish
endif
let g:loaded_mapswap = 1

let s:old_cpo = &cpo
set cpo&vim
" }}}


if !exists('g:mapswap_table')
  let g:mapswap_table = {}
endif
if !exists('g:mapswap_fook')
  let g:mapswap_hook = {}
endif

function! s:mapswap_modes(A, L, P) "{{{1
  return keys(g:mapswap_table)
  " let R = []
  " for mode in keys(g:mapswap_table)
    " if mode =~# '^\V' . a:A
      " call add(R, mode)
    " endif
  " endfor
  " return R
endfunction "}}}


nnoremap <Plug>(mapswap-dump) :<C-u>call mapswap#dump()<CR>
command! -nargs=1 -complete=customlist,<SID>mapswap_modes
      \ Mapswap :call mapswap#swap(<q-args>)

" FINISH: {{{
let &cpo = s:old_cpo
"}}}
" vim: set fdm=marker:
