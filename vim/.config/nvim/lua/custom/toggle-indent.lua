local M = {}

function M.togglf()
    if vim.opt.softtabstop ~=2 then
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        print("Switched to: Indent with 2 spaces.")
    else
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        print("Switched to: Indent with 4 spaces.")
    end
end

return M
