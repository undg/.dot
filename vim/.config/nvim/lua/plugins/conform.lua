return {
    'stevearc/conform.nvim',
    config = function()
        require('conform').setup({
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform will run multiple formatters sequentially
                python = { 'isort', 'black' },
                -- Conform will run the first available formatter
                javascript = { 'prettier', 'prettier', stop_after_first = true },
                typescript = { 'prettier', 'prettier', stop_after_first = true },
                reacttypescript = { 'prettier', 'prettier', stop_after_first = true },
                typescriptreact = { 'prettier', 'prettier', stop_after_first = true },
            },
        })
    end,
}
