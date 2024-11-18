local M = {}

function M.width()
	return vim.go.columns or vim.fn.winwidth(0)
end

function M.height()
	return vim.fn.winheight(0)
end

return M
