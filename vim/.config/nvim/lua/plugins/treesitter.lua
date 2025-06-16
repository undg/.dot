-- https://github.com/nvim-treesitter/nvim-treesitter

-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		-- 'JoosepAlviste/nvim-ts-context-commentstring', -- helper plugin for comment str and [tj]sx,
		{ 'JoosepAlviste/nvim-ts-context-commentstring', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
		-- Highlight, edit, and navigate code using a fast incremental parsing library
		-- 'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects for treesitter
		{ 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
	},
	lazy = false,
	branch = 'main',
	build = ':TSUpdate',

	config = function()
		local ensure_installed = {
			'css',
			'graphql',
			'html',
			'javascript',
			'jsdoc',
			'jsonc',
			'lua',
			'markdown',
			'markdown_inline',
			'python',
			'regex',
			'scss',
			'tsx',
			'typescript',
			'vim',
			'yaml',
		}
		require 'nvim-treesitter.configs'.setup {
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (or "all")
			ignore_install = { "javascript" },

			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			highlight = {
				enable = true,

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				disable = { "c", "rust" },
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
		}





		--
		-- local ts_configs_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
		--
		-- local not_ok = not ts_configs_ok and 'nvim-treesitter.configs' --
		-- 	or false
		--
		-- if not_ok then
		-- 	vim.notify('plugins/treesitter.configs.lua: missing requirements', vim.log.levels.ERROR)
		-- 	return
		-- end
		--
		-- -- Treesitter configuration
		-- ts_configs.setup({
		-- 	modules = {},
		-- 	ignore_install = {},
		-- 	ensure_installed = ensure_installed,
		-- 	sync_install = false,
		-- 	auto_install = true,
		-- 	highlight = {
		-- 		enable = true, -- false will disable the whole extension
		-- 		use_languagetree = true,
		-- 		-- seen that on teej_dv stream, some magical extra powers to treesitter.
		-- 		-- it looks and behaves better, but have some performance penally
		-- 		additional_vim_regex_highlighting = false,
		-- 	},
		-- 	incremental_selection = {
		-- 		enable = true,
		-- 		keymaps = {
		-- 			init_selection = 'vn',
		-- 			node_incremental = 'vn',
		-- 			scope_incremental = 'vnm',
		-- 			node_decremental = 'vm',
		-- 		},
		-- 	},
		-- 	indent = {
		-- 		enable = true,
		-- 	},
		-- textobjects = {
		-- 	select = {
		-- 		enable = true,
		-- 		lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
		-- 		keymaps = {
		-- 			-- You can use the capture groups defined in textobjects.scm
		-- 			['af'] = '@function.outer',
		-- 			['if'] = '@function.inner',
		-- 			-- ['ac'] = '@class.outer',
		-- 			-- ['ic'] = '@class.inner',
		-- 			['ac'] = '@code_block.outer',
		-- 			['ic'] = '@code_block.inner',
		-- 		},
		-- 	},
		-- 	move = {
		-- 		enable = true,
		-- 		set_jumps = true, -- whether to set jumps in the jumplist
		-- 		goto_next_start = {
		-- 			[']]'] = '@function.outer',
		-- 			[']v'] = '@class.outer',
		-- 		},
		-- 		goto_previous_start = {
		-- 			['[['] = '@function.outer',
		-- 			['[m'] = '@class.outer',
		-- 		},
		-- 		goto_next_end = {
		-- 			[']['] = '@function.outer',
		-- 			[']V'] = '@class.outer',
		-- 		},
		-- 		goto_previous_end = {
		-- 			['[]'] = '@function.outer',
		-- 			['[M'] = '@class.outer',
		-- 		},
		-- 	},
		-- },
		-- rainbow = {
		-- 	enable = true,
		-- 	-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		-- 	extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		-- 	max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- 	-- colors = {}, -- table of hex strings
		-- 	-- termcolors = {} -- table of colour name strings
		-- },
		-- })
	end
}
