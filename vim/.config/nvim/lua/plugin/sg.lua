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

        vim.api.nvim_create_user_command('CodyShortenTypeError', shorten_type_error, {})
        map.normal('<leader>ce', shorten_type_error)
    end,
}
