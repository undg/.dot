return {
    'ThePrimeagen/harpoon',
    config = function()
        local ok_harpoon, harpoon = pcall(require, 'harpoon')
        if not ok_harpoon then
            print('plugins/harpoon.lua: missing requirement')
            return
        end

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

        require('keymap.harpoon')
    end,
}
