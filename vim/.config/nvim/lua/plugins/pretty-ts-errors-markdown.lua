return {
	{
		"youyoumu/pretty-ts-errors.nvim", -- https://github.com/youyoumu/pretty-ts-errors.nvim

		config = function()
			local ts_errors = require 'pretty-ts-errors'

			ts_errors.setup({
				{
					-- Install server with
					-- npm i -g pretty-ts-errors-markdown
					executable = "pretty-ts-errors-markdown", -- Path to the executable
					float_opts = {
						border = "rounded",    -- Border style for floating windows
						max_width = 80,        -- Maximum width of floating windows
						max_height = 20,       -- Maximum height of floating windows
						wrap = true,           -- Whether to wrap long lines
					},
					auto_open = false,         -- Automatically show errors on hover
				}
			})

			Keymap.normal("<leader>xs", ts_errors.open_all_errors, { desc = "(pretty-ts-errors) open in split" })
			Keymap.normal("<leader>xt", ts_errors.toggle_auto_open, { desc = "(pretty-ts-errors) toggle auto open" })
			Keymap.normal("<leader>xx", ts_errors.show_formatted_error,
				{ desc = "(pretty-ts-errors) show formatted error" })
		end
	},
}
