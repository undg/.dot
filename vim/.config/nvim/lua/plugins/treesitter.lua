-- https://github.com/nvim-treesitter/nvim-treesitter

-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'JoosepAlviste/nvim-ts-context-commentstring', -- helper plugin for comment str and [tj]sx,
		-- { 'JoosepAlviste/nvim-ts-context-commentstring', dependencies = { 'nvim-treesitter/nvim-treesitter' } },

		-- Highlight, edit, and navigate code using a fast incremental parsing library
		'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects for treesitter
		-- { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
	},
	lazy = false,
	branch = 'main',
	build = ':TSUpdate',

	config = function()
		local ts_configs_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')

		local not_ok = not ts_configs_ok and 'nvim-treesitter.configs' --
			or false

		if not_ok then
			vim.notify('plugins/treesitter.configs.lua: missing requirements', vim.log.levels.ERROR)
			return
		end

		-- Treesitter configuration
		ts_configs.setup({
			modules = {},
			ignore_install = {},
			ensure_installed = ensure_installed,
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true, -- false will disable the whole extension
				use_languagetree = true,
				-- seen that on teej_dv stream, some magical extra powers to treesitter.
				-- it looks and behaves better, but have some performance penally
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = 'vn',
					node_incremental = 'vn',
					scope_incremental = 'vnm',
					node_decremental = 'vm',
				},
			},
			indent = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						-- ['ac'] = '@class.outer',
						-- ['ic'] = '@class.inner',
						['ac'] = '@code_block.outer',
						['ic'] = '@code_block.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']]'] = '@function.outer',
						[']v'] = '@class.outer',
					},
					goto_previous_start = {
						['[['] = '@function.outer',
						['[m'] = '@class.outer',
					},
					goto_next_end = {
						[']['] = '@function.outer',
						[']V'] = '@class.outer',
					},
					goto_previous_end = {
						['[]'] = '@function.outer',
						['[M'] = '@class.outer',
					},
				},
			},
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
		})
	end
}
