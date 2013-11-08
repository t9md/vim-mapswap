"=============================================================================
" File: mapswap.vim
" Author: t9md <taqumd@gmail.com>
" WebPage: http://github.com/t9md/vim-mapswap
" License: ?
" Version: 0.0000001
"=============================================================================
" GUARD: {{{
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
  let mapswap_table = {}
endif
nnoremap <Plug>(mapswap-dump) :<C-u>call mapswap#dump()<CR>
command! -nargs=1 Mapswap :call mapswap#swap(<q-args>)

" FINISH: {{{
let &cpo = s:old_cpo
"}}}
" vim: set fdm=marker:
