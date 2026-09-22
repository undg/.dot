local herdr_navigation = require("custom.lazygit-nav.herdr")

return {
	"willfish/herdr-navigator.nvim",
	config = function()
		local herdr_nav = require("herdr-navigator")
		herdr_nav.setup({
			mappings = {
				left = "<M-h>",
				down = "<M-j>",
				up = "<M-k>",
				right = "<M-l>",
			},
			herdr_executable = "herdr",
		})

		-- lazygit.nvim opens a terminal in a floating window. The plugin's default
		-- navigation runs wincmd first, which moves from the float to the window
		-- underneath instead of handing control to herdr. Keep terminal-insert mode
		-- intact so lazygit accepts input immediately when focus returns.
		local function wrap_terminal(vim_dir, herdr_dir)
			return function()
				if herdr_navigation.is_window(vim.api.nvim_get_current_win()) then
					herdr_navigation.navigate(herdr_dir)
					return
				end
				herdr_nav.navigate_terminal(vim_dir, herdr_dir)
			end
		end

		Keymap.terminal("<M-h>", wrap_terminal("h", "left"))
		Keymap.terminal("<M-j>", wrap_terminal("j", "down"))
		Keymap.terminal("<M-k>", wrap_terminal("k", "up"))
		Keymap.terminal("<M-l>", wrap_terminal("l", "right"))
	end,
}
