-- https://github.com/kdheepak/lazygit.nvim

return {
    'kdheepak/lazygit.nvim',
    config = function()
        vim.g.lazygit_floating_window_winblend = 0                          -- transparency of floating window
        vim.g.lazygit_floating_window_scaling_factor = 0.9                  -- scaling factor for floating window
        vim.g.lazygit_floating_window_border_chars = "['╭', '╮', '╰', '╯']" -- customize lazygit popup window corner characters
        vim.g.lazygit_floating_window_use_plenary = 0                       -- use plenary.nvim to manage floating window if available
        vim.g.lazygit_use_neovim_remote = 0                                 -- fallback to 0 if neovim-remote is not installed
        vim.g.lazygit_use_custom_config_file_path = 0                       -- config file path is evaluated if this value is 1
        vim.g.lazygit_config_file_path = ''                                 -- custom config file path

        require("telescope").load_extension("lazygit")

        local keymap = require('utils.keymap')
        keymap.normal('<leader>gg', ':LazyGit<cr>')
    end,
}