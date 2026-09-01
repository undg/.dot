local window = require("custom.lazygit-nav.window")

local M = {}

M.is_window = window.is_window
M.find_window = window.find_window
M.focus = window.focus

local tmux_directions = {
	h = "L",
	j = "D",
	k = "U",
	l = "R",
}

---@param direction "h"|"j"|"k"|"l"
---@return boolean
function M.navigate(direction)
	local tmux_socket = vim.env.TMUX and vim.env.TMUX:match("^[^,]+")
	local tmux_direction = tmux_directions[direction]
	if not tmux_socket or not tmux_direction then
		return false
	end

	vim.fn.system({ "tmux", "-S", tmux_socket, "select-pane", "-" .. tmux_direction })
	return true
end

return M
