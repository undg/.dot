return {
    'sourcegraph/sg.nvim',
    config = function()
        -- Sourcegraph configuration. All keys are optional
        require('sg').setup({
            -- Pass your own custom attach function
            --        - gd -> goto definition
            --        - gr -> goto references
            -- on_attach = your_custom_lsp_attach_function,
        })
    end,
}
