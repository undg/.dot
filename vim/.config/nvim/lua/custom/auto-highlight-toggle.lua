vim.api.cmd([[
    " <HIGHLIGHT ALL INSTANCES OF WORD UNDER CURSOR, WHEN IDLE>
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    function! AutoHighlightToggle()
    ┊   let @/ = ''
    ┊   if exists('#auto_highlight')
    ┊   ┊   au! auto_highlight
    ┊   ┊   augroup! auto_highlight
    ┊   ┊   setl updatetime=4000
    ┊   ┊   echom 'Highlight current word: off'
    ┊   ┊   return 0
    ┊   else
    ┊   ┊   augroup auto_highlight
    ┊   ┊   ┊   au!
    ┊   ┊   ┊   au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    ┊   ┊   augroup end
    ┊   ┊   setl updatetime=500
    ┊   ┊   echom 'Highlight current word: ON'
    ┊   ┊   return 1
    ┊   endif
    endfunction

    noremap <leader>hh :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
]])

