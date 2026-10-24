local M = {}

---@param task MarkdownMarker
function M.toggle(task)
	local replacement = task.text == "[ ]" and "x" or " "
	vim.api.nvim_buf_set_text(task.bufnr, task.row, task.start_col + 1, task.row, task.end_col - 1, { replacement })
end

return M
