return {
    'gbprod/yanky.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    config = function()
        require('yanky').setup({
            ring = {
                history_length = 16,
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
        require('keymap.yanky')

        -- telescope integration
        require('telescope').load_extension('yank_history')
    end,
}
