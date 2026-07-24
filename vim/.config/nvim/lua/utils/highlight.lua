local M = {}

local namespace = vim.api.nvim_create_namespace("highlight_lines")
M.highlight_group = "HighlightLinePresent"

local function get_highlighted_lines(buffer)
	local highlighted = {}
	for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(buffer, namespace, 0, -1, {})) do
		highlighted[mark[2]] = mark[1]
	end
	return highlighted
end

local function highlight_line(buffer, line)
	vim.api.nvim_buf_set_extmark(buffer, namespace, line - 1, 0, {
		hl_group = M.highlight_group,
		end_row = line,
		end_col = 0,
		hl_eol = true,
	})
end

---@param start_line integer
---@param end_line integer
function M.highlight_lines(start_line, end_line)
	local buffer = vim.api.nvim_get_current_buf()
	local line_count = vim.api.nvim_buf_line_count(buffer)
	local first_line = math.max(start_line, 1)
	local last_line = math.min(end_line, line_count)
	local highlighted = get_highlighted_lines(buffer)

	for line = first_line, last_line do
		if not highlighted[line - 1] then
			highlight_line(buffer, line)
		end
	end
end

---@param start_line integer
---@param end_line integer
function M.toggle_lines(start_line, end_line)
	local buffer = vim.api.nvim_get_current_buf()
	local line_count = vim.api.nvim_buf_line_count(buffer)
	local first_line = math.max(start_line, 1)
	local last_line = math.min(end_line, line_count)
	local highlighted = get_highlighted_lines(buffer)

	for line = first_line, last_line do
		local row = line - 1
		if highlighted[row] then
			vim.api.nvim_buf_del_extmark(buffer, namespace, highlighted[row])
		else
			highlight_line(buffer, line)
		end
	end
end

function M.clear_matches()
	vim.api.nvim_buf_clear_namespace(vim.api.nvim_get_current_buf(), namespace, 0, -1)
end

return M
