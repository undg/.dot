local anchors = require("custom.markdown.anchors")

local M = {}

local function warn(message)
	vim.notify(message, vim.log.levels.WARN, { title = "Markdown" })
end

local function decode(value)
	return value:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end)
end

local function jump(fragment, same_buffer)
	local row, err = anchors.find(vim.api.nvim_get_current_buf(), fragment)
	if not row then
		warn(err)
		return
	end
	if same_buffer then
		vim.cmd.normal({ args = { "m'" }, bang = true })
	end
	vim.api.nvim_win_set_cursor(0, { row, 0 })
	vim.cmd.normal({ args = { "zv" }, bang = true })
end

---@param destination string
function M.follow(destination)
	destination = destination:gsub("^<", ""):gsub(">$", "")
	if destination:lower():match("^https?://") then
		local ok, process, err = pcall(vim.ui.open, destination)
		if not ok or not process then
			warn("Could not open URL: " .. tostring(ok and err or process))
		end
		return
	end

	if destination:match("^[%a][%w+.-]*:") or destination:match("^//") then
		warn("Unsupported link scheme: " .. destination)
		return
	end
	local path, fragment = destination:match("^(.-)#(.*)$")
	path = path or destination
	if path:find("?", 1, true) then
		warn("Local link queries are not supported yet: " .. destination)
		return
	end
	if fragment then
		fragment = decode(fragment)
		if fragment:find("[%z\r\n]") then
			warn("Invalid heading fragment: " .. destination)
			return
		end
	end
	if path == "" and fragment then
		jump(fragment, true)
		return
	end

	path = decode(path:gsub("\\([%p])", "%1"))
	if path == "" or path:find("%z") or path:find("[\r\n]") then
		warn("Invalid local link: " .. destination)
		return
	end
	if not vim.startswith(path, "/") then
		local source = vim.api.nvim_buf_get_name(0)
		if source == "" then
			warn("Save this Markdown file before following relative links")
			return
		end
		path = vim.fs.dirname(source) .. "/" .. path
	end
	path = vim.fs.normalize(path)

	if vim.fn.filereadable(path) ~= 1 then
		warn("Link target does not exist: " .. path)
		return
	end

	local source_bufnr = vim.api.nvim_get_current_buf()
	local ok, err = pcall(vim.cmd.edit, { args = { path }, magic = { file = false } })
	if not ok then
		warn("Could not open link: " .. tostring(err))
		return
	end
	if fragment then
		jump(fragment, vim.api.nvim_get_current_buf() == source_bufnr)
	end
end

return M
