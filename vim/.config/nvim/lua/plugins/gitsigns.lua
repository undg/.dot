return {
	'lewis6991/gitsigns.nvim', -- https://github.com/lewis6991/gitsigns.nvim
	config = function()
		local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')

		local not_ok = not gitsigns_ok and 'gitsigns' --
			or false

		if not_ok then
			vim.notify('plugins/gitsigns.lua: missing requirement - ' .. not_ok, vim.log.levels.ERROR)
			return
		end

		gitsigns.setup({
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
				untracked = { text = '┆' },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = function(status)
				local added, changed, removed = status.added, status.changed, status.removed
				local status_txt = {}
				if added and added > 0 then
					table.insert(status_txt, '+' .. added)
				end
				if changed and changed > 0 then
					table.insert(status_txt, '~' .. changed)
				end
				if removed and removed > 0 then
					table.insert(status_txt, '-' .. removed)
				end
				return table.concat(status_txt, ' ')
			end,
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = 'single',
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']}', function()
					if vim.wo.diff then
						return ']}'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, { expr = true })

				map('n', '[{', function()
					if vim.wo.diff then
						return '[{'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, { expr = true })

				-- Actions
				map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = 'gitsigns: stage_hunk' })
				-- map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
				map('n', '<leader>gs', gs.stage_hunk, { desc = 'gitsigns: preview_hunk' })
				map('n', '<leader>gu', gs.reset_hunk, { desc = 'gitsigns: reset_hunk' })
				map('n', '<leader>gU', gs.reset_buffer, { desc = 'gitsigns: reset_buffer' })
				map('n', '<leader>gp', gs.preview_hunk, { desc = 'gitsigns: preview_hunk' })
				map('n', '<leader>gP', gs.diffthis, { desc = 'gitsigns: diffthis' })
				-- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
				-- map('n', '<leader>tb', gs.toggle_current_line_blame)
				-- map('n', '<leader>hD', function() gs.diffthis('~') end)
				-- map('n', '<leader>td', gs.toggle_deleted)

				-- Text object
				map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end,
		})
	end,
}
