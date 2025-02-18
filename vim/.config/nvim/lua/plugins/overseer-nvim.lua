return {
	"stevearc/overseer.nvim", -- https://github.com/stevearc/overseer.nvim
	opts = {
		task_list = {
			-- Default detail level for tasks. Can be 1-3.
			default_detail = 1,
			-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_width and max_width can be a single value or a list of mixed integer/float types.
			-- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
			max_width = { 100, 0.2 },
			-- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
			min_width = { 40, 0.1 },
			-- optionally define an integer/float for the exact width of the task list
			width = nil,
			max_height = { 80, 0.1 },
			min_height = 30,
			height = nil,
			-- String that separates tasks
			separator = "────────────────────────────────────────",
			-- Default direction. Can be "left", "right", or "bottom"
			direction = "bottom",
		},
	},

	keys = {
		{ "<leader>fv",  "",                             desc = "Overseer command" },
		{ "<leader>fvv", "<cmd>OverseerRun<cr>",         desc = "Run" },
		{ "<leader>fvj", "<cmd>OverseerToggle<cr>",      desc = "Toggle" },
		{ "<leader>fvk", "<cmd>OverseerTaskAction<cr>",  desc = "TaskAction" },
		{ "<leader>fvl", "<cmd>OverseerQuickAction<cr>", desc = "QuickAction" },
	},
}
