local M = {
	"akinsho/bufferline.nvim", -- https://github.com/akinsho/bufferline.nvim
	dependencies = {
		"moll/vim-bbye",
		"nvim-tree/nvim-web-devicons",
	},
	version = "*",
}

local opts = {
	options = {
		mode = "buffers",
		numbers = "both",
		close_command = "Bdelete! %d",
		right_mouse_command = "vertical sbuffer %d",
		middle_mouse_command = "horizontal sbuffer %d",
		left_mouse_command = "buffer %d",
		indicator = {
			icon = "▎",
			style = "icon",
		},
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 18,
		max_prefix_length = 15,
		truncate_names = true,
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level)
			local icon = " ℹ"
			if level == "error" then
				icon = " "
			end
			if level == "warning" then
				icon = " "
			end
			return count .. icon
		end,
		custom_filter = nil,
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		show_duplicate_prefix = true,
		persist_buffer_sort = true,
		separator_style = "slant",
		enforce_regular_tabs = false,
		always_show_bufferline = true,
		hover = {
			enabled = false,
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "id",
	},
}

function M.config()
	local bufferline_ok, bufferline = pcall(require, "bufferline")

	if not bufferline_ok then
		vim.notify("plugins/bufferline.lua: missing bufferline", vim.log.levels.ERROR)
		return
	end

	bufferline.setup(opts)

	-- Go to absolute buffer number (pinned buffers stay at fixed positions)
	Keymap.normal("<leader>bj", function()
		bufferline.go_to_buffer(1, true)
	end, { desc = "BufferLine Go to 1" })
	Keymap.normal("<leader>bk", function()
		bufferline.go_to_buffer(2, true)
	end, { desc = "BufferLine Go to 2" })
	Keymap.normal("<leader>bl", function()
		bufferline.go_to_buffer(3, true)
	end, { desc = "BufferLine Go to 3" })
	Keymap.normal("<leader>b;", function()
		bufferline.go_to_buffer(4, true)
	end, { desc = "BufferLine Go to 4" })
	Keymap.normal("<leader>b'", function()
		bufferline.go_to_buffer(5, true)
	end, { desc = "BufferLine Go to 5" })
	Keymap.normal("<leader>b$", function()
		bufferline.go_to_buffer(-1, true)
	end, { desc = "BufferLine Go to last" })

	-- Cycle
	Keymap.normal("<C-h>", ":BufferLineCyclePrev<cr>", { desc = "BufferLine Cycle prev" })
	Keymap.normal("<C-l>", ":BufferLineCycleNext<cr>", { desc = "BufferLine Cycle next" })

	-- Move
	Keymap.normal("<C-j>", ":BufferLineMovePrev<cr>", { desc = "BufferLine Move prev" })
	Keymap.normal("<C-k>", ":BufferLineMoveNext<cr>", { desc = "BufferLine Move next" })

	-- Pin
	Keymap.normal("<leader>bb", ":BufferLineTogglePin<CR>", { desc = "BufferLine Toggle Pin" })
	Keymap.normal("<leader>BB", ":BufferLineTogglePin<CR>:lua require'bufferline'.move_to(1)<cr>:BufferLineTogglePin<CR>", { desc = "BufferLine Move buffer to START" })
	Keymap.normal("<leader>b^", ":lua require'bufferline'.move_to(1)<cr>", { desc = "BufferLine Move buffer to START" })
	Keymap.normal("<leader>b$", ":lua require'bufferline'.move_to(#vim.fn.getbufinfo({buflisted = 1}))<cr>", { desc = "BufferLine Move buffer to END" })

	-- Close
	Keymap.normal("<leader>bdh", ":BufferLineCloseLeft<CR>", { desc = "Close Buffers on the Left" })
	Keymap.normal("<leader>bdl", ":BufferLineCloseRight<CR>", { desc = "Close Buffers on the Right" })

	-- Telescope
	Keymap.normal("<leader>bt", ":Telescope buffers<CR>", { desc = "Show buffers in Telescope" })

	-- which-key groups
	local wkey_ok, wk = pcall(require, "which-key")
	if wkey_ok then
		wk.add({
			{ "<leader>b", group = "Buffer" },
			{ "<leader>bd", group = "Buffer Close" },
		})
	end
end

return M
