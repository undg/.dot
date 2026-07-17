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

	-- terminal: lazygit.nvim opens lazygit in a floating terminal, so tmux
	-- Alt+h/j/k/l must be handled in terminal mode too
	Keymap.terminal("<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
	Keymap.terminal("<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
	Keymap.terminal("<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
	Keymap.terminal("<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
	Keymap.terminal("<M-Bslash>", nvim_tmux_nav.NvimTmuxNavigateLastActive)

	-- terminal fallback for macOS without a real alt key
	Keymap.terminal("˙", nvim_tmux_nav.NvimTmuxNavigateLeft)
	Keymap.terminal("∆", nvim_tmux_nav.NvimTmuxNavigateDown)
	Keymap.terminal("˚", nvim_tmux_nav.NvimTmuxNavigateUp)
	Keymap.terminal("¬", nvim_tmux_nav.NvimTmuxNavigateRight)
end

return M
