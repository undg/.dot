return {
    'mfussenegger/nvim-lint',
    config = function()
        local lint = require('lint')

        lint.linters.eslint.cmd = './node_modules/.bin/eslint'

        lint.linters_by_ft = {
            javascript = { 'eslint' },
            javascriptreact = { 'eslint' },
            typescript = { 'eslint' },
            typescriptreact = { 'eslint' },
        }
    end,
}
