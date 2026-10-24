local M = {}

local function warn(message)
	vim.notify(message, vim.log.levels.WARN, { title = "Markdown" })
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
	if destination:find("#", 1, true) or destination:find("?", 1, true) then
		warn("Local link fragments and queries are not supported yet: " .. destination)
		return
	end

	local path = destination:gsub("\\([%p])", "%1"):gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end)
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

	local ok, err = pcall(vim.cmd.edit, { args = { path }, magic = { file = false } })
	if not ok then
		warn("Could not open link: " .. tostring(err))
	end
end

return M
