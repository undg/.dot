-- https://github.com/hrsh7th/nvim-cmp

local M = {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-nvim-lua',
		'hrsh7th/cmp-nvim-lsp',
		'quangnguyen30192/cmp-nvim-ultisnips',
	},
}
function M.config()
	local cmp_ok, cmp = pcall(require, 'cmp')
	local lspkind_ok, lspkind = pcall(require, 'lspkind')
	local cmp_ultisnips_mappings_ok, cmp_ultisnips_mappings = pcall(require, 'cmp_nvim_ultisnips.mappings')

	local not_ok = not cmp_ok and 'cmp' --
		or not lspkind_ok and 'lspkind'
		or not cmp_ultisnips_mappings_ok and 'cmp_nvim_ultisnips.mappings'
		or false

	if not_ok then
		vim.notify('plugins/nvim-cmp.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
		return
	end

	-- Set completeopt to have a better completion experience
	vim.o.completeopt = 'menu,menuone,noinsert,noselect'

	cmp.setup({
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = {
			-- ['<C-k>'] = cmp.mapping.select_prev_item(),
			['<Up>'] = cmp.mapping.select_prev_item(),
			-- ['<C-j>'] = cmp.mapping.select_next_item(),
			['<Down>'] = cmp.mapping.select_next_item(),
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-u>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = false,
			}),
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
				end
			end),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					cmp_ultisnips_mappings.jump_backwards(fallback)
				end
			end),
		},
		sources = {
			{ name = 'nvim_lsp', keyword_length = 1 },
			{ name = 'nvim_lua', keyword_length = 1 },
			{ name = 'path', keyword_length = 1 },
			{ name = 'ultisnips' },
			{ name = 'buffer', keyword_length = 3 },
			{ name = 'spell', keyword_length = 3 },
			-- { name = 'codeium',   keyword_length = 3 },
			-- { name = 'cody' },
		},
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
			end,
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol',
				ellipsis_char = '…',

				with_text = false,
				maxwidth = 50,
				menu = {
					nvim_lsp = '',
					nvim_lua = '',
					path = '',
					ultisnips = '✂',
					buffer = '',
					spell = '',
					codeium = '',
					cody = '',
				},
			}),
		},
	})
end

return M
