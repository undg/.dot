return {
	"willfish/herdr-navigator.nvim",
	config = function()
		require("herdr-navigator").setup({
			mappings = {
				left = "<M-h>",
				down = "<M-j>",
				up = "<M-k>",
				right = "<M-l>",
			},
			herdr_executable = "herdr",
		})
	end,
}
