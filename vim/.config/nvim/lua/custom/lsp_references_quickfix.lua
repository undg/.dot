local function lsp_references_quickfix()
	local current_win = vim.api.nvim_get_current_win()

	vim.lsp.buf.references(nil, {
		on_list = function(options)
			vim.fn.setqflist({}, " ", {
				title = options.title,
				items = options.items,
				context = options.context,
			})
			vim.cmd("copen")

			if vim.api.nvim_win_is_valid(current_win) then
				vim.api.nvim_set_current_win(current_win)
			end
		end,
	})
end

return lsp_references_quickfix
