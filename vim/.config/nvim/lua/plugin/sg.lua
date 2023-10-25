local map = require('utils.map')

return {
    'sourcegraph/sg.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Sourcegraph configuration. All keys are optional
        local sg = require('sg')
        local cody_commands = require('sg.cody.commands')
        sg.setup({
            on_attach = function(client, bufnr)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
            end,
        })

        local function shorten_type_error()
            vim.diagnostic.goto_prev()
            local error = vim.diagnostic.get_next().message
            vim.diagnostic.goto_next()

            cody_commands.ask({
                'Explain this diagnostic in shortest possible way. Remove all unnecesary noise, make it short and sweet.'
                .. error,
            })
        end

        local function generate_commit_message()
            vim.api.nvim_command(
                'CodyTask '
                ..
                'Suggest an informative commit message by summarizing code changes from the shared command output. The commit message should provide meaningful context for future readers.'
                .. vim.fn.system('git diff --cached')
            )
        end

        local function generate_readme()
            vim.api.nvim_command(
                'CodyTask '
                ..
                'Write a detailed README.md file to document the code located in the same directory as my current selection. Summarize what the code in this directory is meant to accomplish. Explain the key files, functions, classes, and features. Use Markdown formatting for headings, code blocks, lists, etc. to make the it organized and readable. Aim for a beginner-friendly explanation that gives a developer unfamiliar with the code a good starting point to understand it. Make sure to include: - Overview of directory purpose - Functionality explanations - Relevant diagrams or visuals if helpful. Write the README content clearly and concisely using complete sentences and paragraphs based on the shared context. Use proper spelling, grammar, and punctuation throughout. Surround your full README text with triple backticks so it renders properly as a code block. Do not make assumptions or fabricating additional details.'
                .. vim.fn.system('ls %:p:h')
            )
        end

        vim.api.nvim_create_user_command('CodyGenCommitMessage', generate_commit_message, {})
        vim.api.nvim_create_user_command('CodyGenGitCommitMessage', function()
            vim.api.nvim_command('G commit')
            generate_commit_message()
        end, {})

        vim.api.nvim_create_user_command('CodyGenReadme', generate_readme, {})
        vim.api.nvim_create_user_command('CodyShortenTypeError', shorten_type_error, {})
        map.normal('<leader>ce', shorten_type_error)
    end,
}
