return {
	{
		'nvim-telescope/telescope.nvim',                             -- https://github.com/nvim-telescope/telescope.nvim
		dependencies = {
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
			'nvim-telescope/telescope-ui-select.nvim',               -- https://github.com/nvim-telescope/telescope-ui-select.nvim
			{
				'danielfalk/smart-open.nvim',                        -- https://github.com/danielfalk/smart-open.nvim
				dependencies = {
					'kkharji/sqlite.lua',                            -- https://github.com/kkharji/sqlite.lua
					{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- Only required if using match_algorithm fzf
				},
			},
			{
				'princejoogie/dir-telescope.nvim', -- https://github.com/princejoogie/dir-telescope.nvim
				config = function()
					require('dir-telescope').setup({
						-- these are the default options set
						hidden = true,
						no_ignore = false,
						show_preview = true,
					})
				end,
			},
			{
				'undg/telescope-gp-agent-picker.nvim', -- https://github.com/undg/telescope-gp-agent-picker.nvim
				-- dir = '~/Code/telescope-gp-agent-picker.nvim', -- path to plugin for local development
			},
		},

		config = function()
			local telescope_ok, telescope = pcall(require, 'telescope')
			local actions_ok, actions = pcall(require, 'telescope.actions')
			local tb_ok, tb = pcall(require, 'telescope.builtin')
			local get_visual_selection_ok, get_visual_selection = pcall(require, 'custom.get-visual-selection')

			local not_ok = not telescope_ok and 'telescope' --
				or not actions_ok and 'telescope.actions'
				or not tb_ok and 'telescope.builtin'
				or not get_visual_selection_ok and 'custom.get-visual-selection'
				or false

			if not_ok then
				vim.notify('plugins/telescope.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
				return
			end

			telescope.setup({
				defaults = {
					-- Default configuration for telescope goes here:
					-- config_key = value,
					layout_strategy = 'vertical',
					layout_config = { height = 0.9, width = 0.9 },
					mappings = {
						i = {
							['<C-n>'] = actions.move_selection_next,
							['<C-j>'] = actions.move_selection_next,
							['<Down>'] = actions.move_selection_next,
							['<C-p>'] = actions.move_selection_previous,
							['<C-k>'] = actions.move_selection_previous,
							['<Up>'] = actions.move_selection_previous,

							['<CR>'] = actions.select_default,
							['<C-l>'] = actions.select_default,

							['<C-x>'] = actions.select_horizontal,
							['<C-v>'] = actions.select_vertical,
							['<C-t>'] = actions.select_tab,

							['<C-u>'] = nil,
							['<PageUp>'] = actions.results_scrolling_up,
							['<C-d>'] = nil,
							['<PageDown>'] = actions.results_scrolling_down,

							['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
							['<C-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
							['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
							['<C-S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
							['<C- >'] = actions.toggle_selection,

							['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
							['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
							-- ["<C-l>"] = actions.complete_tag,
							['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
							['<C-w>'] = { '<c-s-w>', type = 'command' },

							['<esc>'] = actions.close,
							['<C-c>'] = actions.close,
							['<C-m>'] = nil,
						},
					},
				},
				pickers = {},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					smart_open = {
						cwd_only = true,
						show_scores = true,
						ignore_patterns = { '*.git/*', '*/tmp/*', '*/node_modules/*' },
						match_algorithm = 'fzf',
						disable_devicons = false,
						open_buffer_indicators = { previous = '👀', others = '🙈' },
					},
					gp_picker = {
						chat_mode = 'chat', -- 'chat' 'command' 'both' (default)
					},
				},
			})

			-- load_extension's, somewhere after setup function:

			telescope.load_extension('fzf')
			telescope.load_extension('ui-select')
			telescope.load_extension('smart_open')
			telescope.load_extension('gp_picker')

			Keymap.normal('<leader>m', ':Telescope<cr>')
			-- keymap.normal(',.', ':Telescope find_files hidden=false<cr>')
			Keymap.normal(',.', ':Telescope smart_open<cr>') -- smart_open telescope _extension
			Keymap.normal('<leader>,', ':Telescope smart_open cwd_only=false<cr>')
			Keymap.normal('<leader>.f', telescope.extensions.dir.find_files)
			Keymap.normal('<leader>.g', telescope.extensions.dir.live_grep)

			Keymap.normal('<leader>fb', ':Telescope buffers<cr>')
			Keymap.normal('<leader>fB', ':Telescope git_branches<cr>')
			Keymap.normal('<leader>fg', ':Telescope live_grep<cr>')
			Keymap.normal('<leader>fG', telescope.extensions.dir.live_grep)
			Keymap.normal('<leader>fr', ':Telescope resume<cr>')

			local open_quick_fix_window_in_telescope = function()
				vim.cmd('cclose')
				tb.quickfix({ fname = 0.5, trim_text = false, show_line = false })
			end
			Keymap.normal('fq', open_quick_fix_window_in_telescope, { desc = 'Open QuickFix in Telescope' })

			Keymap.normal('<leader>fQ', ':Telescope quickfixhistory<cr>')
			Keymap.normal('<leader>fp', ':Telescope project<cr>')
			Keymap.normal('<leader>fo', ':Telescope oldfiles cwd_only=true<cr>')
			Keymap.normal('<leader>fh', ':Telescope help_tags<cr>')
			Keymap.normal('<leader>fm', ':Telescope keymaps<cr>')
			Keymap.normal('<leader>fc', ':Telescope commands<cr>')
			Keymap.normal('<leader>:', ':Telescope commands<cr>')

			Keymap.normal('<leader>fa', ':Telescope gp_picker agent<cr>', { desc = 'gp.nvim Agent Picker' })

			Keymap.visual('<leader>fg', function()
				tb.live_grep({ default_text = get_visual_selection() })
			end, { noremap = true, silent = true })
		end,
	},
}
