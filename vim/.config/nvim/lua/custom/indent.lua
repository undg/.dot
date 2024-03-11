local function toggle()
    if vim.g.softtabstop == 2 then
        vim.g.softtabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
        vim.notify('Switched to: Indent with 4 spaces.', vim.log.levels.INFO, { title = 'IndentToggle' })
    else
        vim.g.softtabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.notify('Switched to: Indent with 2 spaces.', vim.log.levels.INFO, { title = 'IndentToggle' })
    end
end

vim.api.nvim_create_user_command('IndentToggle', toggle, {})
-- ts/sw 2<-->4 toggle indentation
Keymap.normal('<leader>st', toggle, { silent = false })
