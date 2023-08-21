local configs = require('lspconfig/configs')

return {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    settings = {
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = 'separateLine',
            },
            showDocumentation = {
                enable = true,
            },
        },
        codeActionOnSave = {
            enable = false,
            mode = 'all',
        },
        format = true,
        nodePath = vim.NIL,
        onIgnoredFiles = 'off',
        packageManager = 'npm',
        quiet = false,
        rulesCustomizations = {},
        run = 'onType',
        useESLintClass = false,
        validate = 'on',
        workingDirectory = {
            mode = 'location',
        },
    },
    commands = {
        EslintFixAll = {
            function()
                configs.eslint.fix_all({ sync = true, bufnr = 0 })
            end,
            description = 'Fix all eslint problems for this buffer',
        },
    },
}
