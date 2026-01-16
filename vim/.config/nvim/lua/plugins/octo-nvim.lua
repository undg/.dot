return {
	'pwntester/octo.nvim',         -- https://github.com/pwntester/octo.nvim
	dependencies = {
		'nvim-lua/plenary.nvim',   -- https://github.com/nvim-lua/plenary.nvim,
		'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim,
		-- OR 'ibhagwan/fzf-lua', https://github.com/ ibhagwan/fzf-lua,
		'nvim-tree/nvim-web-devicons', -- https://github.com/nvim-tree/nvim-web-devicons,
	},
	config = function()
		require('octo').setup({
			default_merge_method = "squash", -- default merge method which should be used for both `Octo pr merge` and merging from picker, could be `merge`, `rebase` or `squash`
			notifications = {
				current_repo_only = true, -- show notifications for current repo only
			},

		})
	end,
}
