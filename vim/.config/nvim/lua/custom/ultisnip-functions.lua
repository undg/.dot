-- Function `GetCommentMarker()` is used in ultisnip to auto comment `todo` snippet
vim.cmd([[
  function GetCommentMarker()
  if len(split(&l:commentstring, '%s')) == 1
  " if 'commentstring' xx%sxx contains no end part
      return split(&l:commentstring, '%s')[0]
    elseif match(&l:comments, '\v(,|^):[^,:]*(,|$)')
      " if 'comments' contains ',:xxx,'
      return matchstr(&l:comments, '\v(,|^):\zs[^,:]*\ze(,|$)')
    else
  echoerr "unable to find line comment marker."
  endif
  endfunction
]])
