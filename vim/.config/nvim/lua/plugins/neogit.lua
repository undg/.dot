-- https://github.com/NeogitOrg/neogit

-- https://github.com/nvim-lua/plenary.nvim
-- https://github.com/nvim-telescope/telescope.nvim
-- https://github.com/sindrets/diffview.nvim
-- https://github.com/ibhagwan/fzf-lua

local M = {
    'NeogitOrg/neogit',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'sindrets/diffview.nvim',
        'ibhagwan/fzf-lua',
    },
}

function M.config()
    require('neogit').setup({
        enhanced_diff_hl = false,
    })
    local keymap = require('utils.keymap')

    keymap.normal('<leader>gm', ':Neogit<cr>', { desc = 'Neogit: Open' })
    keymap.normal('<leader>gf', ':DiffviewFileHistory<cr>', { desc = 'Neogit: Open diff for current file' })
    keymap.visual('<leader>gf', ':DiffviewFileHistory<cr>', { desc = 'Neogit: Open Open diff for current selection' })
    keymap.normal('<leader>gq', ':DiffviewClose<cr>', { desc = 'Neogit: Close' })
end

return M
