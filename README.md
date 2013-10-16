# VERY EXPERIMENTAL STATE AND LUCK BASIC FEATURE


# mapswap swap keymap temporarily

Since we spend more time to reading 'code' than editing 'code'.
So to save your weak pinky, this plugin helps you temporarily swap keymap and 
restore to original keymap.

* [help](https://github.com/t9md/vim-mapswap/blob/master/doc/mapswap.txt)
* See [kana/vim-submode](https://github.com/kana/vim-submode) and [It's discussion](https://github.com/kana/vim-submode/issues/1)

# mapswap swap keymap temporarily
    " you can swap keymap temporarily with '<F9>' to save your pinky!
    let mapswap_table = {}
    function! mapswap_table.view()
      call mapswap#map('n', '', 'f', '<C-f>')
      call mapswap#map('n', '', 'b', '<C-b>')
      call mapswap#map('n', '', 'u', '<C-u>')
      call mapswap#map('n', '', 'd', '<C-d>')
      call mapswap#map('n', '', '<CR>', '<C-]>')
      call mapswap#map('n', '', '<BS>', '<C-t>')
      call mapswap#map('n', '', '<Space>', '<C-d>')
    endfunction
    nnoremap <F9> :call mapswap#swap('view')<CR>
    nmap   <S-F9> <Plug>(mapswap-dump)
