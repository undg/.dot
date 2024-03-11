return {
    'rcarriga/nvim-notify',      -- https://github.com/rcarriga/nvim-notify
    dependencies = {
        'mrded/nvim-lsp-notify', -- https://github.com/mrded/nvim-lsp-notify
    },
    config = function()
        require('lsp-notify').setup({ notify = require('notify') })

        vim.notify = require('notify')

        Keymap.normal('<leader><esc>', require('telescope').extensions.notify.notify)
    end,
}
