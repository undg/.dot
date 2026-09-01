local window = require("custom.lazygit-nav.window")

local M = {}

M.is_window = window.is_window
M.find_window = window.find_window
M.focus = window.focus

---@param direction "left"|"right"|"up"|"down"
---@return boolean
function M.navigate(direction)
	local args = { "herdr", "pane", "focus", "--direction", direction }
	local pane_id = vim.env.HERDR_PANE_ID
	if pane_id and pane_id ~= "" then
		table.insert(args, "--pane")
		table.insert(args, pane_id)
	else
		table.insert(args, "--current")
	end
	vim.fn.system(args)
	return true
end

return M
