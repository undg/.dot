function get_register_lines(register)
	local content = vim.fn.getreg(register)
	if content == "" then
		return {}
	end

	-- Split by newlines into table
	local lines = vim.split(content, "\n", { plain = true })

	-- Remove last empty line if exists (common with line-wise yanks)
	if lines[#lines] == "" then
		table.remove(lines, #lines)
	end

	return lines
end

function pasteBufFromYank()
	local files = get_register_lines('"')
	for _, line in ipairs(files) do
		files[_] = "> ##buffer:" .. line
	end
	vim.api.nvim_put(files, "l", true, true)
end

vim.api.nvim_create_user_command("AiPasteBufFromYank", pasteBufFromYank, {})

--
-- vim.fn.getreg('"')

-- vim.api.nvim_put({vim.fn.getreg('"')}, 'c', true, true)

-- GET ALL
-- always cleaning harpoon buffers, new workflow
-- relay on 3rd party interface
--
-- vs
--
-- GET ONLY SELECTED
-- handle registers with nonsense
