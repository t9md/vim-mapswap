" Utility:
function! s:msg(msg) "{{{
  try
    echohl Function
    echon a:msg
  finally
    echohl Normal
  endtry
endfunction "}}}

function! s:is_include(list, val) "{{{
  for v in a:list
    if v is a:val
      return 1
    endif
  endfor
  return 0
endfunction "}}}

function! s:split(mode) "{{{
  return split(a:mode, '.\zs')
endfunction "}}}

function! s:exe(list) "{{{
  for c in (type(a:list) ==# type([]) ? a:list : [a:list])
    " echo c
    exe c
  endfor
endfunction "}}}

function! s:build_option(options) "{{{
  return join(map(s:split(a:options),'get(s:options_table, v:val)'))
endfunction "}}}

function! s:build_command(map, mode, options, lhs, rhs) "{{{
  let options =  a:mode ==# 'unmap'
        \ ?  ( s:is_include(s:split(a:options), 'b') ? 'b' : '' )
        \ : a:options
  let v = [ a:mode . a:map, s:build_option(options), a:lhs, a:rhs ]
  if a:mode ==# 'unmap'
    call remove(v, -1)
  endif
  return join( filter(v, 'len(v:val)'))
endfunction "}}}

function! s:build_restore_mapcmd(dict, mode) "{{{
  let d = a:dict
  let cmd_part = [
        \ a:mode . (d.noremap ? "noremap" : "map"),
        \ d.buffer ? "<silent>" : '',
        \ d.expr   ? "<expr>"   : '',
        \ d.nowait ? "<nowait>" : '',
        \ d.silent ? "<silent>" : '',
        \ d.lhs,
        \ d.rhs,
        \ ]
  return join(filter(cmd_part, 'len(v:val)'))
endfunction "}}}

" Option_table:
" {{{
let s:options_table = {
      \ "b": "<buffer>",
      \ "e": "<expr>",
      \ "s": "<silent>",
      \ "u": "<unique>",
      \ "n": "<nowait>",
      \ "S": "<script>",
      \ "l": "<special>",
      \ }
"}}}

" Object:
let s:map = {
      \ "_table": [],
      \ "_mapcmd": [],
      \ "_restore_cmd": [],
      \ }

function! s:map.restore() "{{{
  call s:exe(self._restore_cmd)
  let self._restore_cmd = []
  let self._table = []
  call s:msg( "Restored: " . self._modename() . " --" )
endfunction "}}}

function! s:map._modename() "{{{
  return join( s:map._table , '|')
endfunction "}}}

function! s:map.swap(name, merge) "{{{
  " let need_restore =
  " \ ( !empty(self._saved) && !a:merge ) ||
  " \ ( a:merge && s:is_include(self._table, a:name))
  let need_restore = !empty(self._restore_cmd)
  if need_restore
    call self.restore()
    return
  endif

  let F = get(g:mapswap_table, a:name) 
  if type(F) ==# 2
    call call(F, [], {})
    call s:exe(self._mapcmd)
    call add(self._table, a:name)
    let  self._mapcmd = []
    call s:msg( "Swapped: -- " . self._modename() . " --" )
  endif
endfunction "}}}

function! s:map.dump() "{{{
  echo PP(self)
endfunction "}}}

function! s:map._map(map, mode, options, lhs, rhs) "{{{
  let m = map(s:split(a:mode),
        \ "s:build_command(a:map, v:val , a:options, a:lhs, a:rhs)")
  let self._mapcmd = self._mapcmd + m

  for mode in s:split(a:mode)
    let d = maparg(a:lhs, a:mode , 0, 1)
    let r = empty(d)
          \ ? s:build_command('unmap', mode, a:options, a:lhs,'')
          \ : s:build_restore_mapcmd(d, mode)
    let self._restore_cmd = self._restore_cmd + [r]
  endfor
endfunction "}}}

" PublicAPI:
function! mapswap#swap(name, ...) "{{{
  let merge = a:0 ==# 1 ? a:1 : 0
  call s:map.swap(a:name, merge)
endfunction "}}}

function! mapswap#setup() "{{{
  for name in keys(g:mapswap_table)
    call s:exe(s:build_virtual_map(name))
  endfor
endfunction "}}}

function! s:build_virtual_map(name) "{{{
  return 'nnoremap <Plug>(mapswap-'
        \ . a:name . ') :<C-u>call mapswap#swap("' . a:name . '")<CR>'
endfunction "}}}

function! mapswap#_map(map, mode, options, lhs, rhs) "{{{
  call s:map._map(a:map, a:mode, a:options, a:lhs, a:rhs)
endfunction "}}}

function! mapswap#noremap(mode, options, lhs, rhs) "{{{
  call mapswap#_map('noremap', a:mode, a:options, a:lhs, a:rhs)
endfunction "}}}

function! mapswap#map(mode, options, lhs, rhs) "{{{
  call mapswap#_map('map', a:mode, a:options, a:lhs, a:rhs)
endfunction "}}}

function! mapswap#dump() "{{{
  call s:map.dump()
endfunction "}}}

function! mapswap#restore() "{{{
  call s:map.restore()
endfunction "}}}

function! mapswap#statusline() "{{{
  return empty(s:map._table) ? '' : '-' . s:map._modename() . "-"
endfunction "}}}

" vim: foldmethod=marker
