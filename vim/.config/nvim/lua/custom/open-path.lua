local highlight_ok, highlight = pcall(require, "utils.highlight")
local marks_ok, marks = pcall(require, "utils.marks")

local not_ok = not highlight_ok and "utils.highlight" --
	or not marks_ok and "utils.marks"
	or false

if not_ok then
	vim.notify("custom/open-path.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
	return
end

local M = {}

local function parse_input(raw)
	if raw == nil then
		return nil, nil, nil
	end

	local text = vim.trim(raw)
	if text == "" then
		return nil, nil, nil
	end

	-- > #file:`path:L3-L10`
	-- > #file:`path:L{line}-L{end_line}`
	text = text:gsub("^> #file:`", ""):gsub("`$", "")

	-- path:3:10
	-- path:{line}:{column}
	local path, line, column = text:match("^(.-):(%d+):(%d+)$")
	if path then
		return path, tonumber(line), nil, tonumber(column)
	end

	local end_line
	-- path:L3-L10
	-- path:L{line}-L{end_line}
	path, line, end_line = text:match("^(.-):L(%d+)-L(%d+)$")
	if not path then
		-- path:3-10
		-- path:{line}-{end_line}
		path, line, end_line = text:match("^(.-):(%d+)-(%d+)$")
	end
	if path then
		return path, tonumber(line), tonumber(end_line)
	end

	-- path:L3
	-- path:L{line}
	path, line = text:match("^(.-):L(%d+)$")
	if path then
		return path, tonumber(line), nil
	end

	-- path:3
	-- path:{line}
	path, line = text:match("^(.-):(%d+)$")
	if path then
		return path, tonumber(line), nil
	end

	return text, nil, nil
end

local function git_root()
	local root = vim.fn.system("git rev-parse --show-toplevel")
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return vim.trim(root)
end

---@param path string
---@param line? integer
---@param end_line? integer
---@param column? integer 1-based column
---@return boolean opened
function M.open(path, line, end_line, column)
	if not path or path == "" then
		vim.notify("Path is empty", vim.log.levels.INFO, { title = "Openpath" })
		return false
	end

	if vim.fn.filereadable(path) ~= 1 then
		local root = git_root()
		if root then
			local candidate = root .. "/" .. path
			if vim.fn.filereadable(candidate) == 1 then
				path = candidate
			end
		end
	end

	if vim.fn.filereadable(path) ~= 1 then
		vim.notify("Invalid path: [ " .. path .. " ]", vim.log.levels.WARN, { title = "Openpath" })
		return false
	end

	vim.cmd.edit(vim.fn.fnameescape(path))

	-- Keep the range end on the opened buffer for later commands to use.
	vim.b.openpath_end_line = end_line

	if line then
		local max_line = vim.api.nvim_buf_line_count(0)
		local target_line = math.min(math.max(line, 1), max_line)
		local target_end_line = math.min(math.max(end_line or line, target_line), max_line)
		vim.api.nvim_win_set_cursor(0, { target_line, math.max((column or 1) - 1, 0) })
		highlight.highlight_lines(target_line, target_end_line)

		local mark_letter = marks.assign(vim.api.nvim_get_current_buf(), target_line)
		vim.notify(
			"Marked '" .. mark_letter .. "' (`" .. mark_letter .. " to jump)",
			vim.log.levels.INFO,
			{ title = "Openpath" }
		)

		if line > max_line then
			vim.notify(
				"Line " .. line .. " exceeds file length (" .. max_line .. " lines)",
				vim.log.levels.WARN,
				{ title = "Openpath" }
			)
		end

		if line < 1 then
			vim.notify("Line " .. line .. " can't be less than 1", vim.log.levels.WARN, { title = "Openpath" })
		end
	end

	return true
end

local function open_path()
	local path, line, end_line, column = parse_input(vim.fn.getreg("+"))
	if not path then
		vim.notify("Register + is empty", vim.log.levels.INFO, { title = "Openpath" })
		return
	end

	return M.open(path, line, end_line, column)
end

local function open_path_and_add_to_harpoon()
	if not open_path() then
		return
	end

	local mark_ok, mark = pcall(require, "harpoon.mark")
	if not mark_ok then
		vim.notify("lua/custom/open-path.lua: missing requirements - harpoon.mark", vim.log.levels.ERROR)
		return
	end

	mark.add_file()
	local marked_files = {}
	for index = 1, mark.get_length() do
		marked_files[index] = mark.get_marked_file(index)
	end
	local current_index = mark.get_current_index()
	if current_index and current_index > 1 then
		table.insert(marked_files, 1, table.remove(marked_files, current_index))
		mark.set_mark_list(marked_files)
	end
end

vim.api.nvim_create_user_command("Openpath", open_path, { desc = "Open file path from + register" })
vim.api.nvim_create_user_command("OpenpathHarpoon", open_path_and_add_to_harpoon, {
	desc = "Open file path from + register and move it to the top of Harpoon",
})

Keymap.normal("<leader>Ff", open_path, { desc = "open yanked path" })
Keymap.normal("<leader>FF", open_path_and_add_to_harpoon, { desc = "open yanked path and add to harpoon" })

return M
