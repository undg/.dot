local function toggleConceal()
    if vim.o.conceallevel == 0 then
        vim.o.conceallevel = 1
        vim.notify('Switched to: conceal with level 1.', vim.log.levels.INFO, { title = 'ConcealToggle' })
    else
        vim.o.conceallevel = 0
        vim.notify('Switched to: conceal with level 0.', vim.log.levels.INFO, { title = 'ConcealToggle' })
    end
end

vim.api.nvim_create_user_command('ConcealToggle', toggleConceal, {desc = "Toggle render markdown" })
Keymap.normal('<leader>sc', toggleConceal, { silent = false, desc = "Toggle set=conceallevel (render markdown)" })
