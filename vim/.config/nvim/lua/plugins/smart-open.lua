return {

    'danielfalk/smart-open.nvim',                                       -- https://github.com/danielfalk/smart-open.nvim
    dependencies = {
        'kkharji/sqlite.lua',                                           -- https://github.com/kkharji/sqlite.lua
        'nvim-telescope/telescope.nvim',                                -- https://github.com/nvim-telescope/telescope.nvim
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- Only required if using match_algorithm fzf
        -- { 'nvim-telescope/telescope-fzy-native.nvim' },                 -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    },
    config = function()
        require('yanky').setup({
            ring = {
                history_length = 32,
                storage = 'sqlite',
                sync_with_numbered_registers = true,
            },
            system_clipboard = {
                sync_with_ring = true,
            },
            highlight = {
                on_put = true,
                on_yank = true,
                timer = 100,
            },
            preserve_cursor_position = {
                enabled = true,
            },
        })

        -- key maps
        local keymap = require('utils.keymap')

        -- keymap.normal("p", "<Plug>(YankyPutAfter)")
        -- keymap.normal("P", "<Plug>(YankyPutBefore)")
        -- keymap.xisual("p", "<Plug>(YankyPutAfter)")
        -- keymap.xisual("P", "<Plug>(YankyPutBefore)")
        -- keymap.normal("gp", "<Plug>(YankyGPutAfter)")
        -- keymap.normal("gP", "<Plug>(YankyGPutBefore)")
        -- keymap.xisual("gp", "<Plug>(YankyGPutAfter)")
        -- keymap.xisual("gP", "<Plug>(YankyGPutBefore)")
        --
        -- keymap.normal("<leader>n", "<Plug>(YankyCycleForward)", { noremap = false })
        -- keymap.normal("<leader>N", "<Plug>(YankyCycleBackward)", { noremap = false })
        --
        -- keymap.normal("<leader>y", ":Telescope yank_history<cr>", { noremap = false })

        -- telescope integration
        require('telescope').load_extension('smart_open')
    end,
}
