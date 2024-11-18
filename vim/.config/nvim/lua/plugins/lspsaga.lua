-- @TODO (undg) 2024-06-17: find alternative for diagnostics and definition's, this plugin is bloated
return {
	'nvimdev/lspsaga.nvim', -- https://github.com/nvimdev/lspsaga.nvim
	opts = {
		debug = false,
		diagnostic = {
			show_code_action = false,
		},
		definition = {
			keys = {
				edit = '<leader><enter>',
			},
		},
		symbol_in_winbar = { -- breadcrumbs
			enable = false,
		},
	},
}
