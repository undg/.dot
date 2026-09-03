return {
	"martindur/zdiff.nvim", -- https://github.com/martindur/zdiff.nvim
	config = function()
		local zd = require("zdiff")
		zd.setup({
			------------------------------------------------------
			-- Default config for reference, feel free to delete
			------------------------------------------------------

			-- Whether files are expanded by default
			default_expanded = false,

			-- Default branch for toggle_mode (m key)
			default_branch = "main",

			-- Keymap bindings (defaults)
			keymaps = {
				goto_file = "<CR>",
				toggle = "za",
				close = "q",
				refresh = "r",
				toggle_mode = "m",
				help = "?",
				yank_ref = "gy",
			},

			-- Icons for UI elements
			icons = {
				collapsed = "",
				expanded = "",
				added = "+",
				deleted = "-",
				modified = "~",
			},

			-- Syntax highlighting strategy
			syntax = {
				-- "projection" parses old/new full-file snapshots and projects
				-- captures onto unified diff lines. "hunk" keeps legacy behavior.
				mode = "projection",
				-- Skip projection when either old/new source exceeds this many lines.
				-- 0 means unlimited.
				max_lines = 8000,
			},
		})

		vim.keymap.set("n", "<leader>zd", ":Zdiff<cr>", { desc = "Zdiff (uncommitted)" })
		vim.keymap.set("n", "<leader>zD", ":Zdiff main<cr>", { desc = "Zdiff (vs main)" })
	end,
}
