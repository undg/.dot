-- Sourcegraph configuration. All keys are optional
local ai = require('custom.sg')

return {
    'sourcegraph/sg.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
        require('sg').setup({
            auth_strategy = 'environment-variables',
            on_attach = function(_, bufnr)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
            end,
        })

        -- stylua: ignore start
        vim.api.nvim_create_user_command('AiCommitTitle', ai.commit.title.get, { desc = ai.commit.title.desc })

        vim.api.nvim_create_user_command('AiCommitMessage', ai.commit.message.get, { desc = ai.commit.message.desc })

        vim.api.nvim_create_user_command('AiCommitMessageOpen', ai.commit.open_with_message.get,
            { desc = ai.commit.open_with_message.desc })

        vim.api.nvim_create_user_command('AiPullRequestDescription', ai.pull_request.description.get,
            { desc = ai.pull_request.description.desc })

        vim.api.nvim_create_user_command('AiGenerateReadme', ai.readme.body.get,
            { desc = ai.readme.body.desc })

        vim.api.nvim_create_user_command('AiTypeErrorShort', ai.type_error.shorten.get,
            { desc = ai.type_error.shorten.desc })

        vim.api.nvim_create_user_command('AiTextProofread', ai.text.proofread.get,
            { desc = ai.text.proofread.desc })
        -- stylua: ignore end

        local ok_wk, wk = pcall(require, 'which-key')
        if not ok_wk then
            print('plugin/gp-nvim: "which-key" not found, skipping wk.register')
            return
        end

        wk.register({
            name = 'Cody',
            c = { ':CodyToggle<cr>', 'Cody Toggle' },
            r = { ':CodyRestart<CR>', 'Restart Cody' },
            C = { ':CodyChat<CR>', 'Start a new Cody chat' },
            R = { ':CodyChat!<CR>', 'Reset and start new Cody chat' },
            t = {
                name = 'task',
                t = { ':CodyTask ', 'Create Cody task' },
                v = { ':CodyTaskView<CR>', 'View last Cody task' },
                a = { ':CodyTaskAccept<CR>', 'Accept current Cody task' },
                p = { ':CodyTaskPrev<CR>', 'Cycle to previous Cody task' },
                n = { ':CodyTaskNext<CR>', 'Cycle to next Cody task' },
            },
            a = {
                name = 'automation',
                s = { ai.text.proofread.get, ai.text.proofread.desc },
                r = { ai.readme.body.get, ai.readme.body.desc },
                p = { ai.pull_request.description.get, ai.pull_request.description.desc },
                g = {
                    name = 'git',
                    C = { ai.commit.open_with_message.get, ai.commit.open_with_message.desc },
                    c = { ai.commit.message.get, ai.commit.message.desc },
                    t = { ai.commit.title.get, ai.commit.title.desc },
                },
            },
        }, { prefix = '<leader>ac', mode = 'n' })

        wk.register({
            name = 'Cody',
            a = { ':CodyAsk ', 'Ask Cody a question about current selection' },
            t = {
                name = 'task',
                t = { ':CodyTask ', 'Create Cody task' },
            },
        }, { prefix = '<leader>ac', mode = 'v', silent = false })
    end,
}
