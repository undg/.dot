return {
	'https://github.com/stevearc/oil.nvim',
	config = function()
		require('oil').setup({
			delete_to_trash = false,
			watch_for_changes = true,
			keymaps = {
				['g?'] = 'actions.show_help',
				['<CR>'] = 'actions.select',
				['<C-CR>'] = {
					'actions.select',
					opts = { vertical = true },
					desc = 'Open the entry in a vertical split',
				},
				['<C-h>'] = {
					'actions.select',
					opts = { horizontal = true },
					desc = 'Open the entry in a horizontal split',
				},
				['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
				['<C-p>'] = 'actions.preview',
				['<C-c>'] = 'actions.close',
				['<C-l>'] = 'actions.refresh',
				['-'] = 'actions.parent',
				['_'] = 'actions.open_cwd',
				['`'] = 'actions.cd',
				['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
				['gs'] = 'actions.change_sort',
				['gx'] = 'actions.open_external',
				['g.'] = 'actions.toggle_hidden',
				['g\\'] = 'actions.toggle_trash',
			},
			-- Set to false to disable all of the above keymaps
			use_default_keymaps = false,
		})
		local wkey_ok, wk = pcall(require, 'which-key')

		if not wkey_ok then
			vim.notify('plugins/oil-nvim.lua: missing requirements - whick-key', vim.log.levels.ERROR)
			return
		end
		wk.add({
			{ '<Leader>FF', ':Oil<cr>', desc = 'Open paren directory' },
			{ '<Leader>fF', ':lua require"oil".open_float()<cr>', desc = 'Open paren directory' },
		})
	end,
}
