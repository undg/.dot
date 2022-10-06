-- vim.cmd([[autocmd FileType * set formatoptions-=o]])
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove("o")
    end,
})
