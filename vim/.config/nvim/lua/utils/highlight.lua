local M = {}

---@param start_line integer
---@param end_line integer
function M.highlight_lines(start_line, end_line)
	for line = start_line, end_line do
		vim.fn.matchaddpos("HiglightLinePresent", { line })
	end
end

function M.clear_matches()
	vim.fn.clearmatches()
end

return M
