-- " Automatic toggling between line number modes
-- " [Normal/Visual] hybrid. Relative line numbers and absolute line number on cursor position.
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    callback = function()
        if vim.bo.filetype == "AlphaReady" then
            return
        end
            vim.opt.relativenumber = true
    end,
})
-- " [Insert] absolute line numbers
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    callback = function()
        if vim.bo.filetype == "AlphaReady" then
            return
        end
            vim.opt.relativenumber = false
    end,
})

