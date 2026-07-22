return {

	"FabijanZulj/blame.nvim", -- https://github.com/FabijanZulj/blame.nvim#configuration
	lazy = false,
	config = function()
		require("blame").setup({})
		Keymap.normal("<leader>gb", ":BlameToggle<cr>", { desc = "Blame Toggle" })
	end,
}
