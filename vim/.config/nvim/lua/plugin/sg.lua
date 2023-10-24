local map = require('utils.map')

return {
    'sourcegraph/sg.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Sourcegraph configuration. All keys are optional
        local sg = require('sg')
        local commands = require('sg.cody.commands')
        sg.setup({
            -- Pass your own custom attach function
            --        - gd -> goto definition
            --        - gr -> goto references
            -- on_attach = your_custom_lsp_attach_function,
            -- on_attach = require('lspconfig').on_attach,
        })

        local function shorten_type_error()
            vim.diagnostic.goto_prev()
            local error = vim.diagnostic.get_next().message
            vim.diagnostic.goto_next()

            commands.ask({
                'Explain this diagnostic in shortest possible way. Remove all unnecesary noise, make it short and sweet.'
                .. error,
            })
        end

        local function generate_commit_message()
            local git_diff = vim.fn.system('git diff --cached')

            commands.do_task(
                0,
                2,
                2,
                'Suggest an informative commit message by summarizing code changes from the shared command output. The commit message should follow the conventional commit format and provide meaningful context for future readers. Make first line very short but meaningful.'
                .. git_diff
            )
        end

        local function generate_readme()
            commands.do_task(
                0,
                1,
                1,
                'Write a detailed README.md file to document the code located in the same directory as my current selection. Summarize what the code in this directory is meant to accomplish. Explain the key files, functions, classes, and features. Use Markdown formatting for headings, code blocks, lists, etc. to make the it organized and readable. Aim for a beginner-friendly explanation that gives a developer unfamiliar with the code a good starting point to understand it. Make sure to include: - Overview of directory purpose - Functionality explanations - Relevant diagrams or visuals if helpful. Write the README content clearly and concisely using complete sentences and paragraphs based on the shared context. Use proper spelling, grammar, and punctuation throughout. Surround your full README text with triple backticks so it renders properly as a code block. Do not make assumptions or fabricating additional details.'
            )
        end

        vim.api.nvim_create_user_command('CodyCommitMessage', generate_commit_message, {})
        vim.api.nvim_create_user_command('CodyReadme', generate_readme, {})
        vim.api.nvim_create_user_command('CodyShortenTypeError', shorten_type_error, {})
        map.normal('<leader>ce', shorten_type_error)

    end,
}
