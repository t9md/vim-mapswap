# mapswap swap keymap temporarily

Since we spend more time to reading 'code' than editing 'code'.
So to save your weak pinky, this plugin helps you temporarily swap keymap and 
restore to original keymap.

* [help](https://github.com/t9md/vim-mapswap/blob/master/doc/mapswap.txt)
* See also [kana/vim-submode](https://github.com/kana/vim-submode) and [It's discussion](https://github.com/kana/vim-submode/issues/1)

# mapswap swap keymap temporarily
    " you can swap keymap temporarily with '<F9>' to save your pinky!
    let mapswap_table = {}
    function! mapswap_table.view()
      call mapswap#noremap('n' , '' , 'f'       , '<C-f>')
      call mapswap#noremap('n' , '' , 'b'       , '<C-b>')
      call mapswap#noremap('n' , '' , 'u'       , '<C-u>')

      "second 'n' represent <nowait>. its avoid my global surround-vim mapping wait another key
      call mapswap#noremap('n' , 'n' , 'd'       , '<C-d>') "
      call mapswap#noremap('n' , '' , '<CR>'    , '<C-]>')
      call mapswap#noremap('n' , '' , '<BS>'    , '<C-t>')
      call mapswap#noremap('n' , 'n' , '<Space>' , '<C-d>')

      " you need #map for <Plug> virtual keymap
      call     mapswap#map('n' , '' , 't'       , '<Plug>(quickhl-tag-toggle)')
      call     mapswap#map('n' , '' , 'a'       , '<Plug>(altr-forward)')
    endfunction
    nnoremap <Plug>(mapswap-view) :<C-u>call mapswap#swap('view')<CR>
    nmap     <S-F9> <Plug>(mapswap-dump)
    nmap <F9> <Plug>(mapswap-view)
    " if you like more quicker keymap, idon't need '' since `` is always my favorite.
    " nmap '' <Plug>(mapswap-view)
