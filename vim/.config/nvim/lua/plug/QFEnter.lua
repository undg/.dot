return {
    'yssl/QFEnter', -- quickfix window (cw) open in split/tab...
    config = function()
        vim.cmd([[
                augroup myvimrc
                    autocmd!
                    autocmd QuickFixCmdPost [^l]* cwindow
                    autocmd QuickFixCmdPost l*    lwindow
                augroup END
            ]])
    end,
}
