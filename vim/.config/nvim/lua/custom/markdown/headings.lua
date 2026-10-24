local M = {}

---@param heading MarkdownMarker
---@param delta integer
function M.shift(heading, delta)
	local level = math.max(1, math.min(6, #heading.text + delta))
	if level == #heading.text then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_buf_set_text(
		heading.bufnr,
		heading.row,
		heading.start_col,
		heading.row,
		heading.end_col,
		{ string.rep("#", level) }
	)

	local col = cursor[2]
	if col >= heading.end_col then
		col = col + level - #heading.text
	elseif col >= heading.start_col then
		col = math.min(col, heading.start_col + level - 1)
	end
	vim.api.nvim_win_set_cursor(0, { cursor[1], col })
end

return M
