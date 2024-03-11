return {
    {
        'rcarriga/nvim-notify', -- https://github.com/rcarriga/nvim-notify
        -- dependencies = {
        -- 'mrded/nvim-lsp-notify', -- https://github.com/mrded/nvim-lsp-notify
        -- },
        config = function()
            local telescope_ok, telescope = pcall(require, 'telescope')
            local notify_ok, notify = pcall(require, 'notify')

            local not_ok = not telescope_ok and 'telescope' --
                or false

            if not_ok then
                vim.notify('lua/plugins/notification.lua: require not found - ' .. not_ok, vim.log.levels.ERROR)
            end

            notify.setup({
                top_down = false,
            })

            -- require('lsp-notify').setup({ notify = notify })

            vim.notify = notify

            Keymap.normal('f<esc>', telescope.extensions.notify.notify)
            Keymap.normal('<leader>f<esc>', telescope.extensions.notify.notify)
            Keymap.normal('<leader><esc>', notify.dismiss)
        end,
    },
    {
        'j-hui/fidget.nvim', -- https://github.com/j-hui/fidget.nvim
        config = true,
        opts = {
            notification = {
                window = {
                    align = 'top',
                },
            },
        },
    },
}
