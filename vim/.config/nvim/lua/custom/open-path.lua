local function parse_input(raw)
	if raw == nil then
		return nil, nil
	end

	local text = vim.trim(raw)
	if text == "" then
		return nil, nil
	end

	text = text:gsub("^> #file:`", ""):gsub("`$", "")

	local path, line = text:match("^(.-):L(%d+)$")
	if path then
		return path, tonumber(line)
	end

	path, line = text:match("^(.-):(%d+)$")
	if path then
		return path, tonumber(line)
	end

	return text, nil
end

local function open_path()
	local reg = vim.fn.getreg("+")
	local path, line = parse_input(reg)

	if not path then
		vim.notify("Register + is empty", vim.log.levels.INFO, { title = "Openpath" })
		return
	end

	if vim.fn.filereadable(path) ~= 1 then
		vim.notify("Invalid path: [ " .. path .. " ]", vim.log.levels.WARN, { title = "Openpath" })
		return
	end

	vim.cmd.edit(vim.fn.fnameescape(path))

	if line then
		local max_line = vim.api.nvim_buf_line_count(0)
		local target_line = math.min(math.max(line, 1), max_line)
		vim.api.nvim_win_set_cursor(0, { target_line, 0 })

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

vim.api.nvim_create_user_command("Openpath", open_path, { desc = "Open file path from + register" })
Keymap.normal("<leader>FF", open_path, { desc = "open yanked path" })
