local M = {
	'NeogitOrg/neogit', -- https://github.com/NeogitOrg/neogit
	dependencies = {
		'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim
		'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
		'sindrets/diffview.nvim', -- https://github.com/sindrets/diffview.nvim
		'ibhagwan/fzf-lua', -- https://github.com/ibhagwan/fzf-lua
	},
}

function M.config()
	require('neogit').setup({
		enhanced_diff_hl = false,
	})

	Keymap.normal('<leader>gm', ':Neogit<cr>', { desc = 'Neogit: Open' })
	Keymap.normal('<leader>gf', ':DiffviewFileHistory<cr>', { desc = 'Neogit: Open diff for current file' })
	Keymap.visual('<leader>gf', ':DiffviewFileHistory<cr>', { desc = 'Neogit: Open Open diff for current selection' })
	Keymap.normal('<leader>gq', ':DiffviewClose<cr>', { desc = 'Neogit: Close' })
end

return M
