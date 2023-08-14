local function toggle()
    if vim.g.softtabstop == 2 then
        vim.g.softtabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        print('Switched to: Indent with 4 spaces.')
    else
        vim.g.softtabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        print('Switched to: Indent with 2 spaces.')
    end
end

vim.api.nvim_create_user_command('ToggleIndent', toggle, {})
