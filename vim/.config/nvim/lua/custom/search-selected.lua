vim.cmd([[
vnoremap <silent> * :<C-U>
           \let old_reg=getreg('"')<bar>
           \let old_regmode=getregtype('"')<cr>
           \gvy/<C-R><C-R>=substitute(
           \escape(@", '\\/.*$^~[]'), '\n', '\\n', 'g')<cr><cr>
           \:call setreg('"', old_reg, old_regmode)<cr>
           \<S-n>
]])
