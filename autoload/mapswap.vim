" Utility:
function! s:msg(msg) "{{{
    try
        echohl Function
        echon a:msg
        echohl Normal
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

" Object:
let s:map = {}
let s:map._saved = {}
let s:map._table  = []

function! s:map.save(mode, lhs) "{{{
  let d = maparg(a:lhs, a:mode , 0, 1)
  if empty(d)
    let d = { 
          \ "unmap": 1,
          \ "mode": a:mode,
          \ "lhs": a:lhs,
          \ }
  endif
  let self._saved[a:lhs] = d
endfunction "}}}

function! s:map.restore() "{{{
  for v in values(self._saved)
    if has_key(v, "unmap")
      let cmd_part = [ v.mode . "unmap", v.lhs ]
      let cmd = join(cmd_part)
      exe cmd
    else
      for mode in split(v.mode, '.\zs')
        let cmd_part = [
              \ mode . (v.noremap ? "noremap" : "map"),
              \ v.silent ? "<silent>" : '',
              \ v.buffer ? "<buffer>" : '',
              \ v.expr   ? "<expr>" : '',
              \ v.lhs,
              \ v.rhs,
              \ ]
        let cmd = join(cmd_part)
        exe cmd
      endfor
    endif
  endfor
  let self._saved = {}
endfunction "}}}

function! s:map._modename() "{{{
  return join( s:map._table , '|')
endfunction "}}}

function! s:map.swap(name, merge) "{{{
  let need_restore =
        \ ( !empty(self._saved) && !a:merge ) ||
        \ ( a:merge && s:is_include(self._table, a:name))
  echo need_restore

  if need_restore
    call self.restore()
    call s:msg( "Restored: " . self._modename() . " --" )
    let self._table = []
    return
  endif

  let F = get(g:mapswap_table, a:name) 
  if type(F) ==# 2
    call call(F, [], {})
    call add(self._table, a:name)
    call s:msg( "Swapped: -- " . self._modename() . " --" )
  endif
endfunction "}}}

function! s:map.dump() "{{{
  echo PP(self)
endfunction "}}}

function! s:map._command(mode, option, lhs, rhs) "{{{
  let cmd_part = [
        \ a:mode . 'noremap',
        \ a:lhs,
        \ a:rhs,
        \ ]
  return join(cmd_part)
endfunction "}}}

function! s:map.map(mode, option, lhs, rhs) "{{{
  call self.save(a:mode, a:lhs)
  execute self._command(a:mode, a:option, a:lhs, a:rhs)
endfunction "}}}

" PublicAPI:
function! mapswap#swap(name, ...) "{{{
  let merge = a:0 ==# 1 ? a:1 : 0
  call s:map.swap(a:name, merge)
endfunction "}}}

function! mapswap#map(mode, option, lhs, rhs) "{{{
  call s:map.map(a:mode, a:option, a:lhs, a:rhs)
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
