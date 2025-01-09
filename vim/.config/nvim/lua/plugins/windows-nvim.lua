local M = {
	"anuvyklack/windows.nvim", -- https://github.com/anuvyklack/windows.nvim
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
}
function M.config()
	vim.o.winwidth = 10
	vim.o.winminwidth = 10
	vim.o.equalalways = false
	require("windows").setup()

	local ok_wk, wk = pcall(require, "which-key")

	local not_ok = not ok_wk and "wk not ok\n" or false -- all good, not not_ok

	if not_ok then
		vim.notify("lsp/plugins/windows-nvim.lua: require failed - " .. not_ok, vim.log.levels.ERROR)
		return
	end

	wk.add({
		{ "<leader>w",  group = "Window",                  silent = false },
		{ "<leader>wt", ":WindowsToggleAutowidth<cr>" },
		{ "<leader>ww", ":WindowsEqualize<cr>" },
		{ "<leader>wm", ":WindowsMaximize<cr>" },
		{ "<leader>wv", ":WindowsMaximizeVertically<cr>" },
		{ "<leader>ws", ":WindowsMaximizeHorizontally<cr>" },
	})
end

return M
