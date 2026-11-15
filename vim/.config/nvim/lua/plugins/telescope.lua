return {
	{
		"nvim-telescope/telescope.nvim",                             -- https://github.com/nvim-telescope/telescope.nvim
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
			"nvim-telescope/telescope-ui-select.nvim",               -- https://github.com/nvim-telescope/telescope-ui-select.nvim
			{
				"danielfalk/smart-open.nvim",                        -- https://github.com/danielfalk/smart-open.nvim
				dependencies = {
					"kkharji/sqlite.lua",                            -- https://github.com/kkharji/sqlite.lua
					{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Only required if using match_algorithm fzf
				},
			},
			{
				"princejoogie/dir-telescope.nvim", -- https://github.com/princejoogie/dir-telescope.nvim
				config = function()
					require("dir-telescope").setup({
						-- these are the default options set
						hidden = true,
						no_ignore = false,
						show_preview = true,
					})
				end,
			},
		},

		config = function()
			---------------------------------
			-- check dependencies
			---------------------------------
			local telescope_ok, telescope = pcall(require, "telescope")
			local actions_ok, actions = pcall(require, "telescope.actions")
			local tb_ok, tb = pcall(require, "telescope.builtin")
			local get_visual_selection_ok, get_visual_selection = pcall(require, "custom.get-visual-selection")

			local not_ok = not telescope_ok and "telescope" --
				or not actions_ok and "telescope.actions"
				or not tb_ok and "telescope.builtin"
				or not get_visual_selection_ok and "custom.get-visual-selection"
				or false

			if not_ok then
				vim.notify("plugins/telescope.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
				return
			end

			---------------------------------
			-- setup
			---------------------------------

			telescope.setup({
				defaults = {
					--  @TODO (undg) 2026-07-22: enable diff after parser will get update
					-- The installed diff parser can be older than nvim-treesitter's diff query.
					-- Use Telescope's regex fallback until the parser is updated.
					preview = {
						treesitter = { disable = { "diff" } },
					},
					-- Default configuration for telescope goes here:
					-- config_key = value,
					layout_strategy = "vertical",
					layout_config = { height = 0.9, width = 0.9 },
					mappings = {
						i = {
							["<CR>"] = actions.select_default,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,

							["<C-h>"] = actions.preview_scrolling_left,
							["<C-j>"] = actions.preview_scrolling_down,
							["<C-k>"] = actions.preview_scrolling_up,
							["<C-l>"] = actions.preview_scrolling_right,

							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							["<C-u>"] = nil,
							["<PageUp>"] = actions.results_scrolling_up,
							["<C-d>"] = nil,
							["<PageDown>"] = actions.results_scrolling_down,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<C-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C- >"] = actions.toggle_selection,

							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							-- ["<C-l>"] = actions.complete_tag,
							["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
							["<C-w>"] = { "<c-s-w>", type = "command" },

							["<esc>"] = actions.close,
							["<C-c>"] = actions.close,
							["<C-m>"] = nil,
						},
					},
				},
				pickers = {
					live_grep = {
						additional_args = function()
							return { "--hidden", "-g", "!**/.git/**", "-g", "!**/node_modules/**" }
						end,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					smart_open = {
						cwd_only = true,
						show_scores = true,
						ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
						match_algorithm = "fzf",
						disable_devicons = false,
						open_buffer_indicators = { previous = "👀", others = "🙈" },
					},
					advanced_git_search = {
						-- https://github.com/aaronhallaert/advanced-git-search.nvim#%EF%B8%8F-installation
					},
				},
			})

			---------------------------------
			-- load_extension's, somewhere after setup function:
			---------------------------------

			telescope.load_extension("advanced_git_search")
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("smart_open")

			---------------------------------
			-- keymaps
			---------------------------------

			local open_quick_fix_window_in_telescope = function()
				vim.cmd("cclose")
				tb.quickfix({ fname = 0.5, trim_text = false, show_line = false })
			end

			local function git_bcommits_range_visual()
				local start_line = vim.fn.line("v")
				local end_line = vim.fn.line(".")
				vim.cmd("normal! \\<Esc>")
				tb.git_bcommits_range({
					from = math.min(start_line, end_line),
					to = math.max(start_line, end_line),
				})
			end

			Keymap.normal("<leader>ft", ":Telescope<cr>", { desc = "(telescope) pickers" })
			-- keymap.normal(',.', ':Telescope find_files hidden=false<cr>')
			-- ,. uses smart_open telescope _extension
			Keymap.normal(",.", ":Telescope smart_open<cr>", { desc = "(telescope) smart open" })
			Keymap.normal("<leader>,", ":Telescope smart_open cwd_only=false<cr>", { desc = "(telescope) anywhere" })
			Keymap.normal("<leader>.f", telescope.extensions.dir.find_files, { desc = "(telescope) find files (dir)" })
			Keymap.normal("<leader>.g", telescope.extensions.dir.live_grep, { desc = "(telescope) live grep (dir)" })

			Keymap.normal("<leader>fb", ":Telescope buffers<cr>", { desc = "(telescope) buffers" })
			Keymap.normal("<leader>fs", ":Telescope git_status<cr>", { desc = "(git) status" })
			Keymap.normal("<leader>gc", ":Telescope git_bcommits<cr>", { desc = "(git) commits" })
			Keymap.visual("<leader>gc", git_bcommits_range_visual, { desc = "(git) commits (visual range)" })
			Keymap.normal("<leader>fg", ":Telescope live_grep<cr>", { desc = "(telescope) live grep" })
			Keymap.normal("<leader>fG", telescope.extensions.dir.live_grep, { desc = "(telescope) live grep (dir)" })
			Keymap.normal("<leader>fr", ":Telescope resume<cr>", { desc = "(telescope) resume" })

			Keymap.normal("fq", open_quick_fix_window_in_telescope, { desc = "(telescope) quickfix" })

			Keymap.normal("<leader>fQ", ":Telescope quickfixhistory<cr>", { desc = "(telescope) quickfix history" })
			Keymap.normal("<leader>fo", ":Telescope oldfiles cwd_only=true<cr>", { desc = "(telescope) old files" })
			Keymap.normal("<leader>fh", ":Telescope help_tags<cr>", { desc = "(telescope) help tags" })
			Keymap.normal("<leader>fm", ":Telescope marks<cr>", { desc = "(telescope) marks" })
			Keymap.normal("<leader>fk", ":Telescope keymaps<cr>", { desc = "(telescope) keymaps" })
			Keymap.normal("<leader>fc", ":Telescope commands<cr>", { desc = "(telescope) commands" })
			Keymap.normal("<leader>:", ":Telescope commands<cr>", { desc = "(telescope) commands" })
			Keymap.normal("<leader>fx", ":Telescope diagnostics<cr>", { desc = "(telescope) diagnostics" })

			Keymap.visual("<leader>fg", function()
				tb.live_grep({ default_text = get_visual_selection() })
			end, { noremap = true, silent = true, desc = "(telescope) live grep (visual)" })
		end,
	},
}
