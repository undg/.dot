-- in command line, after TAB, use arrow up/down for completion, instead of left/right.
-- preserver arrow up/down for commands history (when pum is not visible)
vim.cmd([[
  if &wildoptions =~# "pum"
    cnoremap <expr> <up> pumvisible() ? '<left>' : '<up>'
    cnoremap <expr> <down> pumvisible() ? '<right>' : '<down>'
  endif
]])

