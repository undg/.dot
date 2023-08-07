return {
    'ThePrimeagen/harpoon',
    config = function()
        local ok_harpoon, harpoon = pcall(require, 'harpoon')
        if not ok_harpoon then
            print('plugins/harpoon.lua: missing requirement')
            return
        end

        harpoon.setup({
            -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
            save_on_toggle = true,

            -- saves the harpoon file upon every change. disabling is unrecommended.
            save_on_change = true,

            -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
            enter_on_sendcmd = false,

            -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
            tmux_autoclose_windows = false,

            -- filetypes that you want to prevent from adding to the harpoon list menu.
            excluded_filetypes = { 'harpoon' },

            -- set marks specific to each git branch inside git repository
            mark_branch = false,
            menu = {
                width = vim.api.nvim_win_get_width(0) - 20,
            },
        })

        -- keys
        local map = require('utils.map')

        map.normal('<leader>tt', ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
        map.normal('<leader>tr', ':Telescope harpoon marks<cr>')
        map.normal('<leader>ta', ":lua require('harpoon.mark').add_file()<cr>")
        map.normal('<leader>tj', ":lua require('harpoon.ui').nav_next()<cr>")
        map.normal('<leader>tk', ":lua require('harpoon.ui').nav_prev()<cr>")

        map.normal('<leader>fj', ":lua require('harpoon.ui').nav_file(1)<cr>")
        map.normal('<leader>fk', ":lua require('harpoon.ui').nav_file(2)<cr>")
        map.normal('<leader>fl', ":lua require('harpoon.ui').nav_file(3)<cr>")
        map.normal('<leader>f;', ":lua require('harpoon.ui').nav_file(4)<cr>")
        map.normal("<leader>f'", ":lua require('harpoon.ui').nav_file(5)<cr>")
    end,
}
