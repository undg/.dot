local M = {}

-- Border that will match styles that are set in other floating windows
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
M.border = {
	{ '╭', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '╮', 'FloatBorder' },
	{ '│', 'FloatBorder' },
	{ '╯', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '╰', 'FloatBorder' },
	{ '│', 'FloatBorder' },
}

M.style = {
	border = 'rounded',
	style = 'minimal',
	noautocmd = true,
	wrap_at = 40,
}

return M
