-- https://github.com/nvimdev/lspsaga.nvim

return {
    'nvimdev/lspsaga.nvim',
    opts = {
        debug = false,
        diagnostic = {
            show_code_action = false,
        },
        definition = {
            keys = {
                edit = '<leader><enter>',
            },
        },
    },
}
