return {
	"kdheepak/lazygit.nvim", -- https://github.com/kdheepak/lazygit.nvim
	config = function()
		local lazygit_navigation = require("custom.lazygit-navigation")

		require("telescope").load_extension("lazygit")

		Keymap.normal("<leader>gg", function()
			if not lazygit_navigation.focus() then
				vim.cmd("LazyGit")
			end
		end, { desc = "git: lazygit" })

		vim.api.nvim_create_autocmd("FocusGained", {
			callback = function()
				vim.schedule(lazygit_navigation.focus)
			end,
		})
	end,
}
