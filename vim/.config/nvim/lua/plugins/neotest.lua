return {
	"nvim-neotest/neotest", -- https://github.com/nvim-neotest/neotest?tab=readme-ov-file
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- testing framework adapters -- https://github.com/nvim-neotest/neotest?tab=readme-ov-file#supported-runners
		"marilari88/neotest-vitest",
	},
	config = function()
		local neotest = require('neotest')



		---@type neotest.Config?
		---@diagnostic disable-next-line: missing-fields
		local config = {
			quickfix = {
				enabled = false,
				open = false,
			},
			output = {
				enabled = true,
				open_on_run = false
			},
			adapters = {
				require("neotest-vitest") {
					-- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
				},
			}
		}
		neotest.setup(config)



		Keymap.normal("tt", "", { desc = "neotest" })
		Keymap.normal("ttr", function() neotest.run.run() end, { desc = "(neotest) run narest test" })
		Keymap.normal("ttf", function() neotest.run.run(vim.fn.expand("%")) end,
			{ desc = "(neotest) run the curent file" })
		Keymap.normal("ttw", function() neotest.watch.toggle() end, { desc = "(neotest) toggle watch" })
		Keymap.normal("tts", function() neotest.run.stop() end, { desc = "(neotest) stop narest test" })
		Keymap.normal("ttl", function() neotest.run.run_last() end, { desc = "(neotest) run last test" })
		Keymap.normal("tto", ':Neotest output<cr>', { desc = "(neotest) toggle output" })
		Keymap.normal("ttO", function() neotest.output_panel.toggle() end, { desc = "(neotest) toggle output panel" })
		Keymap.normal("ttt", function() neotest.summary.toggle() end, { desc = "(neotest) toggle summary" })
		Keymap.normal("ttj", ":Neotest jump next<cr>", { desc = "(neotest) jump next" })
		Keymap.normal("ttk", ":Neotest jump prev<cr>", { desc = "(neotest) jump prev" })
	end,
}
