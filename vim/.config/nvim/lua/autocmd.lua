-- Fix auto comment
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        -- vim.opt.formatoptions:remove("c")
        -- vim.opt.formatoptions:remove("r")
        vim.opt.formatoptions:remove("o")
    end,
})

-- Set wrap and spell in gitcommit and markdown
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Highligh on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Simplify UI in Alpha plugin page
vim.api.nvim_create_autocmd("User", {
    pattern = { "AlphaReady" },
    callback = function()
        vim.cmd([[ 
            set showtabline=0 | autocmd BufUnload <buffer> set showtabline=1
            set laststatus=0  | autocmd BufUnload <buffer> set laststatus=2
            set nofoldenable  | autocmd BufUnload <buffer> set foldenable
        ]])
    end,
})
