local M = {}

local tmux_directions = {
	h = "L",
	j = "D",
	k = "U",
	l = "R",
}

---@param win integer
---@return boolean
function M.is_window(win)
	if not vim.api.nvim_win_is_valid(win) then
		return false
	end

	local win_config = vim.api.nvim_win_get_config(win)
	if win_config.relative == "" then
		return false
	end

	local buffer = vim.api.nvim_win_get_buf(win)
	return vim.api.nvim_get_option_value("filetype", { buf = buffer }) == "lazygit"
end

---@return integer?
function M.find_window()
	if vim.g.lazygit_opened ~= 1 then
		return nil
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if M.is_window(win) then
			return win
		end
	end

	return nil
end

---@return boolean
function M.focus()
	local win = M.find_window()
	if not win then
		return false
	end

	if vim.api.nvim_get_current_win() ~= win then
		vim.api.nvim_set_current_win(win)
	end

	return true
end

---@param direction string
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
