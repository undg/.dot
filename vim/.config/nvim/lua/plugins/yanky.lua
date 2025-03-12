return {
	'gbprod/yanky.nvim',           -- https://github.com/gbprod/yanky.nvim
	dependencies = {
		'kkharji/sqlite.lua',      -- https://github.com/kkharji/sqlite.lua
		'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
	},
	config = function()
		require('yanky').setup({
			ring = {
				history_length = 32,
				storage = 'sqlite',
				sync_with_numbered_registers = true,
			},
			system_clipboard = {
				sync_with_ring = false,
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 100,
			},
			preserve_cursor_position = {
				enabled = true,
			},
		})

		Keymap.normal('p', '<Plug>(YankyPutAfter)')
		Keymap.normal('P', '<Plug>(YankyPutBefore)')
		Keymap.xisual('p', '<Plug>(YankyPutAfter)')
		Keymap.xisual('P', '<Plug>(YankyPutBefore)')
		Keymap.normal('gp', '<Plug>(YankyGPutAfter)')
		Keymap.normal('gP', '<Plug>(YankyGPutBefore)')
		Keymap.xisual('gp', '<Plug>(YankyGPutAfter)')
		Keymap.xisual('gP', '<Plug>(YankyGPutBefore)')

		Keymap.normal('<leader>n', '<Plug>(YankyCycleForward)', { noremap = false })
		Keymap.normal('<leader>N', '<Plug>(YankyCycleBackward)', { noremap = false })

		Keymap.normal('<leader>y', ':Telescope yank_history<cr>', { noremap = false })

		-- telescope integration
		require('telescope').load_extension('yank_history')
	end,
}
