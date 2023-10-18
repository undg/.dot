return {
    'sourcegraph/sg.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- Sourcegraph configuration. All keys are optional
        require('sg').setup({
            -- Pass your own custom attach function
            --        - gd -> goto definition
            --        - gr -> goto references
            -- on_attach = your_custom_lsp_attach_function,
            -- on_attach = require('lspconfig').on_attach,
        })
    end,
}
