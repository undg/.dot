-- vim.opt.errorformat:append([[,%f\|%\s%#%l col%\s%#%c%\s%#\| %m]])


return {
	"stevearc/overseer.nvim", -- https://github.com/stevearc/overseer.nvim
	config = function()
		local overseer = require 'overseer'
		overseer.setup({
			task_list = {
				-- Default detail level for tasks. Can be 1-3.
				default_detail = 1,
				-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- min_width and max_width can be a single value or a list of mixed integer/float types.
				-- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
				max_width = { 15, 0.2 },
				-- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
				min_width = { 15, 0.1 },
				-- optionally define an integer/float for the exact width of the task list
				width = nil,
				max_height = { 40, 0.1 },
				min_height = 20,
				height = nil,
				-- String that separates tasks
				separator = "────────────────────────────────────────",
				-- Default direction. Can be "left", "right", or "bottom"
				direction = "bottom",
			},
		})

		overseer.register_template({
			name = "npm run lint -- --format compact",
			builder = function()
				return {

					cmd = { "npm", "run", "lint", "--", "--format", "compact" },
					components = {
						"default",
						{ "on_output_parse", problem_matcher = "$eslint-compact" },
						"on_result_diagnostics",
						"on_result_diagnostics_quickfix",
					},
				}
			end,
		})
		overseer.register_template({
			name = "tsc --watch",
			builder = function()
				return {
					cmd = { "npm", "run", "type-check", "--", "--watch" },
					components = {
						"default",
						{ "on_output_parse", problem_matcher = "$tsc-watch" },
						"on_result_diagnostics",
						"on_result_diagnostics_quickfix",
					},
				}
			end,
		})
	end,


	keys = {
		{ "<leader>fv",  group = "Overseer", },
		{ "<leader>fvj", "<cmd>OverseerRun<cr>",         desc = "(Overseer) Run" },
		{ "<leader>fvv", "<cmd>OverseerToggle<cr>",      desc = "(Overseer) Toggle" },
		{ "<leader>fvk", "<cmd>OverseerTaskAction<cr>",  desc = "(Overseer) TaskAction" },
		{ "<leader>fvl", "<cmd>OverseerQuickAction<cr>", desc = "(Overseer) QuickAction" },
	},
}
