local M = {}

local namespace = vim.api.nvim_create_namespace("highlight_lines")
M.highlight_group = "HighlightLinePresent"

---@param start_line integer
---@param end_line integer
function M.highlight_lines(start_line, end_line)
	local buffer = vim.api.nvim_get_current_buf()
	local line_count = vim.api.nvim_buf_line_count(buffer)
	local first_line = math.max(start_line, 1)
	local last_line = math.min(end_line, line_count)

	vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)
	for line = first_line, last_line do
		vim.api.nvim_buf_set_extmark(buffer, namespace, line - 1, 0, {
			hl_group = M.highlight_group,
			end_row = line,
			end_col = 0,
			hl_eol = true,
		})
	end
end

function M.clear_matches()
	vim.api.nvim_buf_clear_namespace(vim.api.nvim_get_current_buf(), namespace, 0, -1)
end

return M
