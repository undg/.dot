return {
	{
		"youyoumu/pretty-ts-errors.nvim", -- https://github.com/youyoumu/pretty-ts-errors.nvim

		-- Install server https://github.com/hexh250786313/pretty-ts-errors-markdown
		build = "npm i -g pretty-ts-errors-markdown",
		config = function()
			local ts_errors_ok, ts_errors = pcall(require, 'pretty-ts-errors')

			local window_ok, window = pcall(require, 'utils.window')

			local not_ok = not window_ok and "utils.window"
				or not ts_errors_ok and 'pretty-ts-errors'
				or false

			if not_ok then
				vim.notify("plugins/pretty-ts-errors-markdown.lua: SKIP, requirement's missing - " .. not_ok,
					vim.log.levels.ERROR)
				return
			end

			ts_errors.setup({
				executable = "pretty-ts-errors-markdown", -- Path to the executable
				float_opts = {
					border = "rounded",                -- Border style for floating windows
					max_width = window.width() - 10,   -- Maximum width of floating windowsutilsutils
					max_height = math.floor(window.height() * 3 / 4), -- Maximum height of floating windows
					wrap = false,                      -- Whether to wrap long lines
				},
				auto_open = false,                     -- Automatically show errors on hover
			})

			Keymap.normal("<leader>xs", ts_errors.open_all_errors, { desc = "(pretty-ts-errors) open in split" })
			Keymap.normal("<leader>xt", ts_errors.toggle_auto_open, { desc = "(pretty-ts-errors) toggle auto open" })
			Keymap.normal("<leader>xx", ts_errors.show_formatted_error,
				{ desc = "(pretty-ts-errors) show formatted error" })
		end
	},
}
