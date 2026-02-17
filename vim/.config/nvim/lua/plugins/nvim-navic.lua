return {
	{
		"SmiteshP/nvim-navic", -- https://github.com/SmiteshP/nvim-navic
		dependencies = {},

		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				lsp = { auto_attach = true },
				highlight = true,
			})

			vim.o.winbar = "  %f > %{%v:lua.require'nvim-navic'.get_location()%}"

			vim.api.nvim_set_hl(0, "WinBar", { bg = "#3c3836", fg = "#d3869b" })
		end,
	},
	{
		"SmiteshP/nvim-navbuddy", -- https://github.com/SmiteshP/nvim-navbuddy
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local navbuddy = require("nvim-navbuddy")

			navbuddy.setup({
				lsp = { auto_attach = true },
				window = { border = "rounded" },
			})
			Keymap.normal("<leader>fn", ":Navbuddy<cr>", { desc = "Navbuddy" })
		end,
	},
}
