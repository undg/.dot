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

        local function gen_commit_message()
            local git_diff = vim.fn.system('git diff --cached')


            commands.do_task(0, 2, 2, 'Suggest an informative commit message by summarizing code changes from the shared command output. The commit message should follow the conventional commit format and provide meaningful context for future readers. Make first line very short but meaningful.' .. git_diff)
        end

        vim.api.nvim_create_user_command('CodyShortenTypeError', shorten_type_error, {})
        map.normal('<leader>ce', shorten_type_error)

        vim.api.nvim_create_user_command('CodyCommitMessage', gen_commit_message, {})
    end,
}
