return {
	'yssl/QFEnter', -- https://github.com/yssl/QFEnter
	init = function()
		vim.cmd([[
                augroup myvimrc
                    autocmd!
                    autocmd QuickFixCmdPost [^l]* cwindow
                    autocmd QuickFixCmdPost l*    lwindow
                augroup END
            ]])
	end,
}
