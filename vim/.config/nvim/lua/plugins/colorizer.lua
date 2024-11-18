local M = {
	'lilydjwg/colorizer', -- https://github.com/lilydjwg/colorizer
	cmd = { 'ColorHighlight', 'ColorToggle' },
	event = 'VeryLazy',
}

function M.init()
	vim.g.colorizer_startup = 0
	vim.g.colorizer_maxlines = 1000
end

return M
