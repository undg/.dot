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
            auth_strategy = 'environment-variables',
        })

        -- stylua: ignore start
        vim.api.nvim_create_user_command('AiCommitTitle', ai.commit.title.get, { desc = ai.commit.title.desc })
        vim.keymap.set('n', '<leader>agt', ai.commit.title.get, { desc = ai.commit.title.desc })

        vim.api.nvim_create_user_command('AiCommitMessage', ai.commit.message.get, { desc = ai.commit.message.desc })
        vim.keymap.set('n', '<leader>agc', ai.commit.message.get, { desc = ai.commit.message.desc })

        vim.api.nvim_create_user_command('AiCommitMessageOpen', ai.commit.open_with_message.get,
            { desc = ai.commit.open_with_message.desc })
        vim.keymap.set('n', '<leader>agg', ai.commit.open_with_message.get, { desc = ai.commit.open_with_message.desc })

        vim.api.nvim_create_user_command('AiPullRequestDescription', ai.pull_request.description.get,
            { desc = ai.pull_request.description.desc })
        vim.keymap.set('n', '<leader>agp', ai.pull_request.description.get, { desc = ai.pull_request.description.desc })

        vim.api.nvim_create_user_command('AiGenerateReadme', ai.readme.body.get,
            { desc = ai.readme.body.desc })

        vim.api.nvim_create_user_command('AiTypeErrorShort', ai.type_error.shorten.get,
            { desc = ai.type_error.shorten.desc })
        vim.keymap.set('n', '<leader>ace', ai.type_error.shorten.get, { desc = ai.type_error.shorten.desc })

        vim.api.nvim_create_user_command('AiTextProofread', ai.type_error.shorten.get,
            { desc = ai.type_error.shorten.desc })
        vim.keymap.set('n', '<leader>actx', ai.text.proofread.get, { desc = ai.text.proofread.desc })
        -- stylua: ignore end

        vim.keymap.set('v', '<leader>aca', ':CodyAsk ')
        vim.keymap.set('n', '<leader>acc', ':CodyToggle<cr>')

        -- Ask Cody a question about current selection
        vim.keymap.set('v', '<leader>aca', ':CodyAsk ')

        -- Start a new Cody chat
        vim.keymap.set('n', '<leader>acc', ':CodyChat<CR>')

        -- Reset and start new Cody chat
        vim.keymap.set('n', '<leader>acC', ':CodyChat!<CR>')

        -- Toggle Cody chat window
        vim.keymap.set('n', '<leader>acc', ':CodyToggle<CR>')

        -- Create Cody task
        vim.keymap.set('v', '<leader>actt', ':CodyTask<CR>')

        -- View last Cody task
        vim.keymap.set('n', '<leader>actv', ':CodyTaskView<CR>')

        -- Accept current Cody task
        vim.keymap.set('n', '<leader>acta', ':CodyTaskAccept<CR>')

        -- Cycle to previous Cody task
        vim.keymap.set('n', '<leader>actp', ':CodyTaskPrev<CR>')

        -- Cycle to next Cody task
        vim.keymap.set('n', '<leader>actn', ':CodyTaskNext<CR>')

        -- Restart Cody
        vim.keymap.set('n', '<leader>acr', ':CodyRestart<CR>')
    end,
}
