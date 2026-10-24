local Keymap = require("utils.keymap")
local context = require("custom.markdown.context")
local links = require("custom.markdown.links")
local checkboxes = require("custom.markdown.checkboxes")
local headings = require("custom.markdown.headings")

local M = {}

function M.enter()
	local current = context.read()
	if current.in_code then
		return
	end

	if current.link then
		links.follow(current.link)
	elseif current.task then
		checkboxes.toggle(current.task)
	end
end

---@param direction integer
function M.shift(direction)
	local current = context.read()
	local count = vim.v.count1
	if current.heading then
		headings.shift(current.heading, direction * count)
		return
	end

	local keys = direction > 0 and ">>" or "<<"
	vim.cmd.normal({ args = { tostring(count) .. keys }, bang = true })
end

---@param bufnr integer
function M.attach(bufnr)
	Keymap.normal("<CR>", M.enter, {
		buffer = bufnr,
		silent = true,
		desc = "Markdown: follow link or toggle checkbox",
	})
	Keymap.normal(">>", function()
		M.shift(1)
	end, { buffer = bufnr, silent = true, desc = "Markdown: deepen heading or indent" })
	Keymap.normal("<<", function()
		M.shift(-1)
	end, { buffer = bufnr, silent = true, desc = "Markdown: promote heading or unindent" })
end

function M.setup()
	local group = vim.api.nvim_create_augroup("custom_markdown", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "markdown",
		callback = function(event)
			M.attach(event.buf)
		end,
	})

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == "markdown" then
			M.attach(bufnr)
		end
	end
end

return M
