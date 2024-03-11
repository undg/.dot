local keymap = require('utils.keymap')
return {
    'echasnovski/mini.notify', -- https://github.com/echasnovski/mini.notify
    version = '*',
    config = function()
        require('mini.notify').setup({
            window = {
                max_width_share = 0.5,
            },
        })

        vim.notify = require('mini.notify').make_notify({
            ERROR = { duration = 5000, hl_group = 'DiagnosticError' },
            WARN = { duration = 5000, hl_group = 'DiagnosticWarn' },
            INFO = { duration = 5000, hl_group = 'DiagnosticInfo' },
            DEBUG = { duration = 0, hl_group = 'DiagnosticHint' },
            TRACE = { duration = 0, hl_group = 'DiagnosticOk' },
            OFF = { duration = 0, hl_group = 'MiniNotifyNormal' },
        })

        vim.api.nvim_create_user_command('NotifyHistoryShow', MiniNotify.show_history, {desc = 'MiniNotify: show history in new buffer'})

        keymap.normal('<leader><esc>', MiniNotify.show_history)
    end,
}
