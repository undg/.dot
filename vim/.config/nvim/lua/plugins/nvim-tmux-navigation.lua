local lazygit_navigation = require("custom.lazygit-navigation")

local M = {
	"alexghergh/nvim-tmux-navigation", -- https://github.com/alexghergh/nvim-tmux-navigation
}

M.opts = {
	disable_when_zoomed = true, -- defaults to false
}

function M.init()
	local nvim_tmux_nav = require("nvim-tmux-navigation")

	Keymap.normal("<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
	Keymap.normal("<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
	Keymap.normal("<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
	Keymap.normal("<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
	Keymap.normal("<M-Bslash>", nvim_tmux_nav.NvimTmuxNavigateLastActive)

	-- move for less capable OS without alt key
	Keymap.normal("˙", nvim_tmux_nav.NvimTmuxNavigateLeft)
	Keymap.normal("∆", nvim_tmux_nav.NvimTmuxNavigateDown)
	Keymap.normal("˚", nvim_tmux_nav.NvimTmuxNavigateUp)
	Keymap.normal("¬", nvim_tmux_nav.NvimTmuxNavigateRight)

	local function terminal_navigation(direction, fallback)
		return function()
			if lazygit_navigation.is_window(vim.api.nvim_get_current_win()) and lazygit_navigation.navigate(direction) then
				return
			end
			fallback()
		end
	end

	-- lazygit.nvim opens a terminal in a floating window. The regular plugin
	-- navigation first runs wincmd, which moves from that float to the window
	-- underneath it instead of handing control to tmux.
	Keymap.terminal("<M-h>", terminal_navigation("h", nvim_tmux_nav.NvimTmuxNavigateLeft))
	Keymap.terminal("<M-j>", terminal_navigation("j", nvim_tmux_nav.NvimTmuxNavigateDown))
	Keymap.terminal("<M-k>", terminal_navigation("k", nvim_tmux_nav.NvimTmuxNavigateUp))
	Keymap.terminal("<M-l>", terminal_navigation("l", nvim_tmux_nav.NvimTmuxNavigateRight))
	Keymap.terminal("<M-Bslash>", nvim_tmux_nav.NvimTmuxNavigateLastActive)

	-- terminal fallback for macOS without a real alt key
	Keymap.terminal("˙", terminal_navigation("h", nvim_tmux_nav.NvimTmuxNavigateLeft))
	Keymap.terminal("∆", terminal_navigation("j", nvim_tmux_nav.NvimTmuxNavigateDown))
	Keymap.terminal("˚", terminal_navigation("k", nvim_tmux_nav.NvimTmuxNavigateUp))
	Keymap.terminal("¬", terminal_navigation("l", nvim_tmux_nav.NvimTmuxNavigateRight))
end

return M
