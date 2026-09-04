local highlight = require("utils.highlight")
local marks = require("utils.marks")

local M = {}

local function parse_input(raw)
	if raw == nil then
		return nil, nil, nil
	end

	local text = vim.trim(raw)
	if text == "" then
		return nil, nil, nil
	end

	text = text:gsub("^> #file:`", ""):gsub("`$", "")

	local path, line, end_line = text:match("^(.-):L(%d+)-L(%d+)$")
	if not path then
		path, line, end_line = text:match("^(.-):(%d+)-(%d+)$")
	end
	if path then
		return path, tonumber(line), tonumber(end_line)
	end

	path, line = text:match("^(.-):L(%d+)$")
	if path then
		return path, tonumber(line), nil
	end

	path, line = text:match("^(.-):(%d+)$")
	if path then
		return path, tonumber(line), nil
	end

	return text, nil, nil
end

---@param path string
---@param line? integer
---@param end_line? integer
function M.open(path, line, end_line)
	if not path or path == "" then
		vim.notify("Path is empty", vim.log.levels.INFO, { title = "Openpath" })
		return
	end

	if vim.fn.filereadable(path) ~= 1 then
		vim.notify("Invalid path: [ " .. path .. " ]", vim.log.levels.WARN, { title = "Openpath" })
		return
	end

	vim.cmd.edit(vim.fn.fnameescape(path))

	-- Keep the range end on the opened buffer for later commands to use.
	vim.b.openpath_end_line = end_line

	if line then
		local max_line = vim.api.nvim_buf_line_count(0)
		local target_line = math.min(math.max(line, 1), max_line)
		local target_end_line = math.min(math.max(end_line or line, target_line), max_line)
		vim.api.nvim_win_set_cursor(0, { target_line, 0 })
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
end

local function open_path()
	local path, line, end_line = parse_input(vim.fn.getreg("+"))
	if not path then
		vim.notify("Register + is empty", vim.log.levels.INFO, { title = "Openpath" })
		return
	end

	M.open(path, line, end_line)
end

local function open_path_and_add_to_harpoon()
	open_path()

	--  @TODO (undg) 2026-08-17: create command, do not rely on mapping
	local keys = vim.api.nvim_replace_termcodes("<S-LEFT><S-RIGHT><S-RIGHT><ESC>", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end

vim.api.nvim_create_user_command("Openpath", open_path, { desc = "Open file path from + register" })
Keymap.normal("<leader>Ff", open_path, { desc = "open yanked path" })
Keymap.normal("<leader>FF", open_path_and_add_to_harpoon, { desc = "open yanked path and add to harpoon" })

return M
