vim.cmd[[
    hi User1 guibg=#FFAF00 guifg=#222222
    hi User2 guibg=#504945 guifg=#191919
    hi User3 guibg=#A8A8A8 guifg=#222222

    set statusline=
    set statusline+=\ %#warningmsg#
    set statusline+=\ %2*%y
    set statusline+=\ %p%%
    set statusline+=\[%L]
    set statusline+=\ %l:%c
    set statusline+=\ %=
    set statusline+=\ %1*\ %.35{getcwd()}\ %*
    set statusline+=\ %3*\ [%{FugitiveHead()}]\ %*
    set statusline+=\ %1*\ %f%m\ %*
]]
-- " Return current branch name to be used in status line.
-- function! GitFileStatus()
--     return system("[[ -n \"$(git status --porcelain " . shellescape(expand("%")) . " 2>/dev/null )\" ]] && echo -n ✰ ")
-- endfunction

-- let s:status = GitFileStatus()

-- function! StatuslineGit()
--     let l:branchname = GitBranch()
--     return strlen(l:branchname) > 0?'['.l:branchname.s:status.']':''
-- endfunction

-- function! GitBranch()
--     return FugitiveHead()
--     " return FugitiveStatusline()
--     " return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
-- endfunction


-- augroup reload_vimrc
--     autocmd!
--     autocmd BufWritePost let s:gitFileStatus = GitFileStatus()
-- augroup END

