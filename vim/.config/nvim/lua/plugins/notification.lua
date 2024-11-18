return {
	{
		'rcarriga/nvim-notify', -- https://github.com/rcarriga/nvim-notify
		-- dependencies = {
		-- 'mrded/nvim-lsp-notify', -- https://github.com/mrded/nvim-lsp-notify
		-- },
		config = function()
			local notify = require('notify')
			notify.setup({
				background_colour = '#000000',
				top_down = false, -- true: top; false: bottom
				fps = 60,
			})

			local telescope_ok, telescope = pcall(require, 'telescope')

			local not_ok = not telescope_ok and 'telescope' --
				or false

			if not_ok then
				vim.notify('lua/plugins/notification.lua: require not found - ' .. not_ok, vim.log.levels.ERROR)
			end

			-- require('lsp-notify').setup({ notify = notify })

			vim.notify = notify

			Keymap.normal('<leader>S', telescope.extensions.notify.notify, { desc = 'List Notifications' })
			Keymap.normal('<leader><esc>', notify.dismiss)
		end,
	},
	{
		'j-hui/fidget.nvim', -- https://github.com/j-hui/fidget.nvim
		config = true,
	},
}
