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
end

return M
