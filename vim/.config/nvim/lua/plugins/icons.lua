return {
	-- icons for lsp
	{ 'onsails/lspkind-nvim' }, -- https://github.com/onsails/lspkind-nvim
	{
		-- icons for telescope and Neotree and all sorts of plugins
		'nvim-tree/nvim-web-devicons', -- https://github.com/nvim-tree/nvim-web-devicons
		config = function()
			local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')

			local not_ok = not devicons_ok and 'nvim-web-devicons' --
				or false

			if not_ok then
				vim.notify('plugins/icons.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
				return
			end

			devicons.setup({
				-- your personnal icons can go here (to override)
				-- DevIcon will be appended to `name`
				override = {
					zsh = {
						icon = '',
						color = '#428850',
						name = 'Zsh',
					},
				},
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true,
			})
		end,
	},
}
