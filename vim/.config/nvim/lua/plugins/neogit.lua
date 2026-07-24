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

	local function diffview_selection_history()
		local start_line = vim.fn.line('v')
		local end_line = vim.fn.line('.')
		vim.cmd('DiffviewFileHistory --range=' .. math.min(start_line, end_line) .. ',' .. math.max(start_line, end_line))
	end

	Keymap.normal('<leader>gm', ':Neogit<cr>', { desc = 'Neogit: Open' })
	Keymap.normal('<leader>gf', ':DiffviewFileHistory %<cr>', { desc = 'Git: File history' })
	Keymap.visual('<leader>gf', diffview_selection_history, { desc = 'Git: Selection history' })
	Keymap.normal('<leader>gh', ':DiffviewFileHistory<cr>', { desc = 'Git: Repository history' })
	Keymap.normal('<leader>gv', ':DiffviewOpen<cr>', { desc = 'Git: Diff working tree' })
	Keymap.normal('<leader>gq', ':DiffviewClose<cr>', { desc = 'Git: Close diffview' })
end

return M
