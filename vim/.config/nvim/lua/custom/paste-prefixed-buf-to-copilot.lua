local M = {}

local function is_not_copilot_chat_buffer()
	return vim.fn.bufname() ~= "copilot-chat"
end

---@param path string
local function validate_path(path)
	return vim.fn.filereadable(path) == 1
end

---@param reg string - register name
function M.get_files_from_register_lines(reg)
	-- get yanked lines from register
	local content = vim.fn.getreg(reg)
	if content == "" then
		return {}
	end

	-- Split by newlines into table
	local yanked = vim.split(content, "\n", { plain = true })

	local files = {}
	local pwd = vim.fn.getcwd()

	for _, line in ipairs(yanked) do
		if line ~= "" and validate_path(line) then
			table.insert(files, "> ##buffer:" .. pwd .. line)
		end
	end

	return files
end

function M.get_files_from_harpoon()
	local ok_harpoon, harpoon = pcall(require, "harpoon")
	if not ok_harpoon then
		vim.notify("paste-prefixed-buf-to-copilot.lua: requirement's missing - " .. "harpoon", vim.log.levels.ERROR)
	end
	---@diagnostic disable-next-line: undefined-field -- this will fail after migration to harpoon 2
	local harpoon_marks = harpoon.get_mark_config().marks
	local files = {}
	local pwd = vim.fn.getcwd()

	for i, mark in ipairs(harpoon_marks) do
		files[i] = "> ##buffer:" .. pwd .. mark.filename
	end
	return files
end

local function pasteBufFromYank()
	if is_not_copilot_chat_buffer() then
		return
	end
	local files = M.get_files_from_register_lines('"')
	vim.api.nvim_put(files, "l", false, true)
end

local function pasteBufFromHarpoon()
	if is_not_copilot_chat_buffer() then
		return
	end
	local files = M.get_files_from_harpoon()

	vim.api.nvim_put(files, "l", false, true)
end

vim.api.nvim_create_user_command("AiPasteBufFromYank", pasteBufFromYank, {})
vim.api.nvim_create_user_command("AiPasteBufFromHarpoon", pasteBufFromHarpoon, {})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "copilot-chat",
	callback = function()
		Keymap.normal("gp", pasteBufFromYank, { buffer = true, desc = "AiPasteBufFromYank" })
		Keymap.normal("gf", pasteBufFromHarpoon, { buffer = true, desc = "AiPasteBufFromYank" })
	end,
})

return M
