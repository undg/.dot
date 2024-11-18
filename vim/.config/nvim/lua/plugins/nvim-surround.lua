local M = {
	'kylechui/nvim-surround', -- https://github.com/kylechui/nvim-surround
	version = '*', -- Use for stability; omit to use `main` branch for the latest features
	event = 'VeryLazy',
}

M.opts = {
	highlight = {
		duration = 200,
	},
}

return M
