return {
	'kdheepak/lazygit.nvim', -- https://github.com/kdheepak/lazygit.nvim
	config = function()
		require('telescope').load_extension('lazygit')

		Keymap.normal('<leader>gg', ':LazyGit<cr>')
	end,
}
