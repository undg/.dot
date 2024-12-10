return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- ADAPTERS
		"marilari88/neotest-vitest",
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-plenary"),
				require("neotest-vim-test")({
					ignore_file_types = { "python", "vim", "lua" },
				}),
				require("neotest-vitest")({
					---@diagnostic disable-next-line: unused-local
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
				}),
			},
		})

		Keymap.normal(
			"<leader>twr",
			"<cmd>lua require('neotest').run.run({ vitestCommand = 'vitest --watch' })<cr>",
			{ desc = "Run Watch" }
		)

		Keymap.normal(
			"<leader>twf",
			"<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), vitestCommand = 'vitest --watch' })<cr>",
			{ desc = "Run Watch File" }
		)
		vim.keymap.set("n", "<Leader>ta", function()
			neotest.run.run(vim.fn.expand("%"))
			neotest.summary.open()
		end, { desc = "Run all tests" })
	end,
}
