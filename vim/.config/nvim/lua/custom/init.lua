require('custom.formater')
require('custom.indent')
require('custom.json2ts')
require('custom.search-selected')
-- require('custom.statusline')
require('custom.css2tw')
require('custom.open-plugin-page')

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

-- in command line, after TAB, use arrow up/down for completion, instead of left/right.
-- preserver arrow up/down for last command when pum is not visible
vim.cmd([[
  if &wildoptions =~# "pum"
    cnoremap <expr> <up> pumvisible() ? '<left>' : '<up>'
    cnoremap <expr> <down> pumvisible() ? '<right>' : '<down>'
  endif
]])
