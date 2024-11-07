return {
    'stevearc/conform.nvim', -- https://github.com/stevearc/conform.nvim
    config = function()
        require('conform').setup({
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'black' },
                bash = { 'shfmt' },
                zsh = { 'shfmt' },
                sh = { 'shfmt' },
                go = { 'goimports', 'gofmt' },
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
                typescript = { 'prettierd', 'prettier', stop_after_first = true },
                reacttypescript = { 'prettierd', 'prettier', stop_after_first = true },
                typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            },
        })

        Keymap.normal('<leader>p', function()
            require('conform').format({ async = true })
        end, { desc = 'Format' })

        Keymap.normal('<LEADER>P', function()
            vim.g.format_on_save = not vim.g.format_on_save

            local msg = 'Format on save = OFF'
            if vim.g.format_on_save then
                msg = 'Format on save = ON'
            end

            vim.notify(msg, vim.log.levels.INFO)
        end, { desc = 'Toggle format on save' })
    end,
}
