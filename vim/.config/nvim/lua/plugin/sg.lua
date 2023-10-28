local map = require('utils.map')

return {
    'sourcegraph/sg.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Sourcegraph configuration. All keys are optional
        local sg = require('sg')
        local types = require('sg.types')
        local cody_commands = require('sg.cody.commands')
        sg.setup({
            on_attach = function(_, bufnr)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
            end,
            auth_strategy = { types.auth_strategy.nvim, types.auth_strategy.env, types.auth_strategy.app },
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
            local git_diff = vim.fn.system('git diff --cached')

            vim.api.nvim_command(
                'CodyTask '
                ..
                ' - Start with a short title that explains the main purpose of the commit. This should be on the first line. Prefix with text text in current line.'
                ..
                ' - Add a blank line after the title, then provide a longer description of the changes if needed. The description should explain why the changes were made and any relevant context. '
                ..
                ' - Use the imperative mood when describing what the commit does. For example: "Update README" rather than "Updated README". '
                ..
                ' - Keep commit messages short but informative. About 50-72 characters for the title, and no more than 72 characters per line in description. '
                .. ' - Check the output of `git diff --cached` to ensure the commit message accurately reflects the changes. '
                .. '```diff'
                .. git_diff
                .. '```'
            )
        end

        local function generate_pr_description()
            local pr_diff = vim.fn.system('gh pr diff')

            local diff
            if #pr_diff < 2000 then
                print('pr_diff shorten than 2k, provide to Cody FULL diff')
                diff = ' - Check the output of `gh diff` to ensure the PR description accurately reflects the changes. '
                    .. '```diff'
                    .. pr_diff
                    .. '```'
            else
                print('pr_diff longer than 2k, provide to Cody only FILE NAMES diff')
                diff =
                    ' - Check the output of `gh diff --name-only` to ensure the PR description accurately reflects the changes. '
                    .. '```diff'
                    .. vim.fn.system('gh pr diff --name-only')
                    .. '```'
            end
            vim.api.nvim_command(
                'CodyTask '
                .. ' - write a detailed PR description with the same context as the commit message, but with a short title.'
                .. diff
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

        vim.api.nvim_create_user_command(
            'CodyGenCommitMessage',
            generate_commit_message,
            { desc = 'Generate commit message' }
        )

        vim.api.nvim_create_user_command('CodyGenGitCommitMessage', function()
            vim.api.nvim_command('G commit')
            generate_commit_message()
        end, { desc = 'Open git commit and generate commit message' })

        vim.api.nvim_create_user_command(
            'CodyGenPrDescription',
            generate_pr_description,
            { desc = 'Generate PR description' }
        )


        vim.api.nvim_create_user_command('CodyGenReadme', generate_readme, { desc = 'Generate README' })

        vim.api.nvim_create_user_command(
            'CodyShortenTypeError',
            shorten_type_error,
            { desc = 'Shorten type error, keep cursor on or before error' }
        )
        map.normal('<leader>ce', shorten_type_error)
    end,
}
