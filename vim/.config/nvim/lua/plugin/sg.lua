-- Sourcegraph configuration. All keys are optional
local ai = require('custom.sg')

return {
    'sourcegraph/sg.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
        local types = require('sg.types')

        require('sg').setup({
            on_attach = function(_, bufnr)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
            end,
            auth_strategy = { types.auth_strategy.env, types.auth_strategy.nvim, types.auth_strategy.app },
        })

        -- stylua: ignore start
        vim.api.nvim_create_user_command('AiCommitTitle', ai.commit.title.get, { desc = ai.commit.title.desc })
        vim.keymap.set('n', '<leader>at', ai.commit.title.get, { desc = ai.commit.title.desc })

        vim.api.nvim_create_user_command('AiCommitMessage', ai.commit.message.get, { desc = ai.commit.message.desc })
        vim.keymap.set('n', '<leader>am', ai.commit.message.get, { desc = ai.commit.message.desc })

        vim.api.nvim_create_user_command('AiCommitMessageOpen', ai.commit.open_with_message.get,
            { desc = ai.commit.open_with_message.desc })
        vim.keymap.set('n', '<leader>ac', ai.commit.open_with_message.get, { desc = ai.commit.open_with_message.desc })

        vim.api.nvim_create_user_command('AiPullRequestDescription', ai.pull_request.description.get,
            { desc = ai.pull_request.description.desc })
        vim.keymap.set('n', '<leader>ap', ai.pull_request.description.get, { desc = ai.pull_request.description.desc })

        vim.api.nvim_create_user_command('AiGenerateReadme', ai.readme.body.get,
            { desc = ai.readme.body.desc })

        vim.api.nvim_create_user_command('AiTypeErrorShort', ai.type_error.shorten.get,
            { desc = ai.type_error.shorten.desc })
        vim.keymap.set('n', '<leader>ae', ai.type_error.shorten.get,
            { desc = ai.type_error.shorten.desc })
        -- stylua: ignore end
    end,
}
