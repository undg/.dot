return {
    'NeogitOrg/neogit',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'sindrets/diffview.nvim',
        'ibhagwan/fzf-lua',
    },
    config = function()
        require('neogit').setup({
            enhanced_diff_hl = false,
        })
        local keymap = require('utils.keymap')

        keymap.normal('<leader>gg', ':Neogit<cr>', { desc = 'Neogit: Open' })
        keymap.normal('<leader>gf', ':DiffviewFileHistory<cr>', { desc = 'Neogit: Open diff for current file' })
        keymap.visual(
            '<leader>gf',
            ':DiffviewFileHistory<cr>',
            { desc = 'Neogit: Open Open diff for current selection' }
        )
        keymap.normal('<leader>gq', ':DiffviewClose<cr>', { desc = 'Neogit: Close' })
    end,
}
