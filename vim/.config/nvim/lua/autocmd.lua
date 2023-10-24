-- Fix auto comment.
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        -- vim.opt.formatoptions:remove("c") -- Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
        -- vim.opt.formatoptions:remove("r") -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
        vim.opt.formatoptions:remove('o') -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
        -- read more... :help fo-table
    end,
})

-- Set wrap and spell in gitcommit and markdown
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Highligh on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    end,
})

-- Set markdown as the filetype for the Cody prompt
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'cody_prompt',
    callback = function()
        vim.bo.filetype = 'markdown'
    end,
})

-- Set markdown as the filetype for the Cody history
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = {'markdown.cody_history', 'markdown.cody_prompt'},
    callback = function()
        vim.bo.filetype = 'markdown'
    end,
})

-- -- Automatic toggling between line number modes
-- -- [Normal/Visual] hybrid. Relative line numbers and absolute on line with cursor position.
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
--     callback = function()
--         -- Simplify UI for certaind filetypes
--         if
--             vim.bo.filetype == 'alpha' --
--             or vim.bo.filetype == 'help'
--             or vim.bo.filetype == 'NvimTree'
--         then
--             vim.opt.relativenumber = false
--             return
--         end
--         vim.opt.relativenumber = true
--     end,
-- })
--
-- -- [Insert] absolute line numbers
-- vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
--     callback = function()
--         vim.opt.relativenumber = false
--     end,
-- })
