return {
	"ChmaraX/herdr-nvim",
	config = function()
		require("herdr-nvim").setup({
			prefix = "<leader>a", -- keymap prefix
			keymaps = true,  -- set false to define your own
			clear_after_send = false, -- comments are ephemeral by design
		})
	end,
}
