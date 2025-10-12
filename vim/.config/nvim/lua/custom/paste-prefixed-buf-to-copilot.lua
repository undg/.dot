local function is_not_copilot_chat_buffer()
	return vim.fn.bufname() ~= "copilot-chat"
end

local function get_register_lines(register)
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

local function get_files_from_harpoon()
	local harpoon_marks = require("harpoon").get_mark_config().marks
	local files = {}

	for i, mark in ipairs(harpoon_marks) do
		files[i] = "> ##buffer:" .. mark.filename
	end
	return files
end

local function pasteBufFromYank()
	if is_not_copilot_chat_buffer() then
		return
	end
	local files = get_register_lines('"')
	table.insert(files, "")
	table.insert(files, "")
	vim.api.nvim_put(files, "l", true, true)
end

local function pasteBufFromHarpoon()
	if is_not_copilot_chat_buffer() then
		return
	end
	local files = get_files_from_harpoon()

	table.insert(files, "")
	table.insert(files, "")
	vim.api.nvim_put(files, "l", true, true)
end

vim.api.nvim_create_user_command("AiPasteBufFromYank", pasteBufFromYank, {})
vim.api.nvim_create_user_command("AiPasteBufFromHarpoon", pasteBufFromHarpoon, {})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "copilot-chat", -- or whatever filetype
	callback = function()
		Keymap.normal("gp", pasteBufFromYank, { buffer = true, desc = "AiPasteBufFromYank" })
		Keymap.normal("gf", pasteBufFromHarpoon, { buffer = true, desc = "AiPasteBufFromYank" })
	end,
})
