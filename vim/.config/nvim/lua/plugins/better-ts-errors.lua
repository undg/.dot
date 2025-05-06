return {
	'OlegGulevskyy/better-ts-errors.nvim', -- https://github.com/OlegGulevskyy/better-ts-errors.nvim
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		require("better-ts-errors").setup({
			keymaps = {
				toggle = '<leader>dd', -- Toggling keymap
				go_to_definition = '<leader>dx' -- Go to problematic type from popup window
			}
		})
	end
}
