return {
	"nvim-treesitter/nvim-treesitter-context", -- https://github.com/nvim-treesitter/nvim-treesitter-context
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local max_lines = math.max(vim.api.nvim_win_get_height(0) - 5, 1)
		require("treesitter-context").setup({
			enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
			multiwindow = false, -- Enable multiwindow support.
			max_lines = max_lines, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 20, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			line_numbers = true,
			multiline_threshold = 20, -- Maximum number of lines to show for a single context
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20, -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		})

		-- Appearance
		-- Use the highlight group TreesitterContext to change the colors of the context. Per default it links to NormalFloat.
		--
		-- Use the highlight group TreesitterContextLineNumber to change the colors of the context line numbers if line_numbers is set. Per default it links to LineNr.
		--
		-- Use the highlight group TreesitterContextSeparator to change the colors of the separator if separator is set. By default it links to FloatBorder.
		--
		-- Use the highlight groups TreesitterContextBottom and/or TreesitterContextLineNumberBottom to change the highlight of the last line of the context window. By default it links to NONE. However, you can use this to create a border by applying an underline highlight, e.g, for an underline across the screen:
		--
		-- hi TreesitterContextBottom gui=underline guisp=Grey
		-- hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
		-- Or an underline below the line numbers only:
		--
		-- hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
		--

		vim.api.nvim_set_hl(0, "TreesitterContext", {
			bg = "#504945",
			-- fg = "#fabd2f",
			bold = true,
			sp = "#fabd2f",
		})

		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
			bg = "#504945",
			fg = "#fabd2f",
			bold = true,
			sp = "#fabd2f",
		})

		vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
			underline = true,
		})
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
			underline = true,
		})
	end,

	vim.keymap.set("n", "<leader>gc", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, { silent = true, desc = "(treesitter) Go to context" }),
}
