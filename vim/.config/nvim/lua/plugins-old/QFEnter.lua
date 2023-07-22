vim.cmd[[
    augroup myvimrc
        autocmd!
        autocmd QuickFixCmdPost [^l]* cwindow
        autocmd QuickFixCmdPost l*    lwindow
    augroup END
]]
