return {
    'ThePrimeagen/harpoon',              -- https://github.com/ThePrimeagen/harpoon
    dependencies = {
        'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
    },
    config = function()
        local harpoon_ok, harpoon = pcall(require, 'harpoon')
        local telescope_ok, telescope = pcall(require, 'telescope')

        local not_ok = not telescope_ok and 'telescope' --
            or not harpoon_ok and 'harpoon'
            or false

        if not_ok then
            vim.notify('plugins/harpoon.lua: missing requirement - ' .. not_ok, vim.log.levels.ERROR)
            return
        end

        telescope.load_extension('harpoon')

        harpoon.setup({
            save_on_toggle = true,              -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
            save_on_change = true,              -- saves the harpoon file upon every change. disabling is unrecommended.
            enter_on_sendcmd = false,           -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
            tmux_autoclose_windows = false,     -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
            excluded_filetypes = { 'harpoon' }, -- filetypes that you want to prevent from adding to the harpoon list menu.
            mark_branch = false,                -- set marks specific to each git branch inside git repository
            menu = {
                width = vim.api.nvim_win_get_width(0) - 20,
            },
        })

        local keymap = require('utils.keymap')

        keymap.normal('<leader>tt', ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
        keymap.normal('<leader>tr', ':Telescope harpoon marks<cr>')
        keymap.normal('<leader>ta', ":lua require('harpoon.mark').add_file()<cr>")
        keymap.normal('<leader>tj', ":lua require('harpoon.ui').nav_next()<cr>")
        keymap.normal('<leader>tk', ":lua require('harpoon.ui').nav_prev()<cr>")

        keymap.normal('<leader>fj', ":lua require('harpoon.ui').nav_file(1)<cr>")
        keymap.normal('<leader>fk', ":lua require('harpoon.ui').nav_file(2)<cr>")
        keymap.normal('<leader>fl', ":lua require('harpoon.ui').nav_file(3)<cr>")
        keymap.normal('<leader>f;', ":lua require('harpoon.ui').nav_file(4)<cr>")
        keymap.normal("<leader>f'", ":lua require('harpoon.ui').nav_file(5)<cr>")
    end,
}
