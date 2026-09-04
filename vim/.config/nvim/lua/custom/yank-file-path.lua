local M = {}

---Skip inside zdiff buffers, "%:p" there resolves to nonsense.
---@return boolean
local function in_zdiff()
	return vim.bo.filetype == "zdiff"
end

---Yank current file path + line number to the `+` register,
---and the same wrapped as a `#file:` reference to the unnamed register.
function M.yank_file_path()
	if in_zdiff() then
		return
	end

	local line_nr = vim.fn.line(".")
	local file_path = vim.fn.expand("%:p") .. ":" .. line_nr
	vim.fn.setreg("+", file_path)
	vim.fn.setreg('"', "> #file:`" .. file_path .. "`")
	vim.notify(file_path, vim.log.levels.INFO, { title = "Yank file path" })
end

---Yank current file path + visual line range to the `+` register,
---and the same wrapped as a `#file:` reference to the unnamed register.
function M.yank_file_path_with_range()
	if in_zdiff() then
		return
	end

	local file_path = vim.fn.expand("%:p")
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")

	-- Handle reverse selection
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local line_range = start_line == end_line and string.format("L%d", start_line)
		or string.format("L%d-L%d", start_line, end_line)

	local file_path_with_lines = file_path .. ":" .. line_range
	vim.fn.setreg("+", file_path_with_lines)
	vim.fn.setreg('"', "> #file:`" .. file_path_with_lines .. "`")
	vim.notify(file_path_with_lines, vim.log.levels.INFO, { title = "Yank file path with lines" })
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
end

Keymap.normal("gy", M.yank_file_path, { desc = "yank file path" })
Keymap.visual("gy", M.yank_file_path_with_range, { desc = "yank file path with line range" })

return M
