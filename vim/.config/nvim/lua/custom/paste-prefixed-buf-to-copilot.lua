local M = {}

local function is_not_copilot_chat_buffer()
	return vim.fn.bufname() ~= "copilot-chat"
end

function M.get_register_lines(register)
	-- get yanked lines from register
	local content = vim.fn.getreg(register)
	if content == "" then
		return {}
	end

	-- Split by newlines into table
	local files = vim.split(content, "\n", { plain = true })

	--  @TODO (undg) 2025-10-12: remove all empty lines and non files lines
	-- Remove last empty line if exists (common with line-wise yanks)
	if files[#files] == "" then
		table.remove(files, #files)
	end

	for i, line in ipairs(files) do
		files[i] = "> ##buffer:" .. line
	end

	return files
end

function M.get_files_from_harpoon()
	local ok_harpoon, harpoon = pcall(require, "harpoon")
	if not ok_harpoon then
		vim.notify("paste-prefixed-buf-to-copilot.lua: requirement's missing - " .. "harpoon", vim.log.levels.ERROR)
	end
	local harpoon_marks = harpoon.get_mark_config().marks
	local files = {}

	for i, mark in ipairs(harpoon_marks) do
		files[i] = "> ##buffer:" .. mark.filename
	end
	return files
end

function M.pasteBufFromYank()
	if is_not_copilot_chat_buffer() then
		return
	end
	local files = M.get_register_lines('"')
	table.insert(files, "")
	table.insert(files, "")
	vim.api.nvim_put(files, "l", true, true)
end

function M.pasteBufFromHarpoon()
	if is_not_copilot_chat_buffer() then
		return
	end
	local files = M.get_files_from_harpoon()

	table.insert(files, "")
	table.insert(files, "")
	vim.api.nvim_put(files, "l", true, true)
end

vim.api.nvim_create_user_command("AiPasteBufFromYank", M.pasteBufFromYank, {})
vim.api.nvim_create_user_command("AiPasteBufFromHarpoon", M.pasteBufFromHarpoon, {})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "copilot-chat", -- or whatever filetype
	callback = function()
		Keymap.normal("gp", M.pasteBufFromYank, { buffer = true, desc = "AiPasteBufFromYank" })
		Keymap.normal("gf", M.pasteBufFromHarpoon, { buffer = true, desc = "AiPasteBufFromYank" })
	end,
})

return M
