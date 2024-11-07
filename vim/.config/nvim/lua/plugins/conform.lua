return {
    'stevearc/conform.nvim',
    config = function()
        require('conform').setup({
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'black' },
                bash = { 'shfmt' },
                zsh = { 'shfmt' },
                sh = { 'shfmt' },
                go = {'goimports', 'gofmt'},
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
                typescript = { 'prettierd', 'prettier', stop_after_first = true },
                reacttypescript = { 'prettierd', 'prettier', stop_after_first = true },
                typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            },
        })
    end,
}
