return {
	'folke/noice.nvim', -- https://github.com/folke/noice.nvim
	opts = {
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				['vim.lsp.util.convert_input_to_markdown_lines'] = true,
				['vim.lsp.util.stylize_markdown'] = true,
				['cmp.entry.get_documentation'] = true,
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		cmdline = {
			enabled = true, -- enables the Noice cmdline UI
			view = 'cmdline_popup', -- `cmdline` | 'cmdline_popup'
			opts = {}, -- global options for the cmdline. See section on views
			---@type table<string, CmdlineFormat>
			format = {
				-- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
				-- view: (default is cmdline view)
				-- opts: any options passed to the view
				-- icon_hl_group: optional hl_group for the icon
				-- title: set to anything or empty string to hide
				cmdline = {
					kind = '',
					view = 'cmdline_popup',
					pattern = '^:',
					icon = '',
					lang = 'vim',
				},
				search_down = {
					kind = 'search',
					view = 'cmdline',
					pattern = '^/',
					icon = ' ',
					lang = 'regex',
				},
				search_up = {
					kind = 'search',
					view = 'cmdline',
					pattern = '^%?',
					icon = ' ',
					lang = 'regex',
				},
				filter = {
					kind = '',
					view = 'cmdline_popup',
					pattern = '^:%s*!',
					icon = '$',
					lang = 'bash',
				},
				lua = {
					kind = '',
					view = 'cmdline_popup',
					pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
					icon = '',
					lang = 'lua',
				},
				help = {
					kind = '',
					view = 'cmdline_popup',
					pattern = '^:%s*he?l?p?%s+',
					icon = '',
				},
				input = {
					kind = '',
					view = 'cmdline_popup',
				}, -- Used by input()
				-- lua = false, -- to disable a format, set to `false`
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		'MunifTanjim/nui.nvim', -- https://github.com/MunifTanjim/nui.nvim
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		'rcarriga/nvim-notify', -- https://github.com/rcarriga/nvim-notify
	},
}
