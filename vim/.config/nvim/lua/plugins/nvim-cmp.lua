-- https://github.com/hrsh7th/nvim-cmp

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").load()
				require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
			end,
		},
	},
	config = function()
		local cmp_ok, cmp = pcall(require, "cmp")
		local lspkind_ok, lspkind = pcall(require, "lspkind")

		local not_ok = not cmp_ok and "cmp" --
			or not lspkind_ok and "lspkind"
			or false

		if not_ok then
			vim.notify("plugins/nvim-cmp.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		-- Set completeopt to have a better completion experience
		vim.o.completeopt = "menu,menuone,noinsert,noselect"

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = {
				["<Up>"] = cmp.mapping.select_prev_item(),
				["<Down>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-u>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = false,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					cmp.select_next_item()
				end),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					cmp.select_prev_item()
				end),
			},
			sources = {
				{ name = "nvim_lsp", keyword_length = 1 },
				{ name = "nvim_lua", keyword_length = 1 },
				{ name = "path",     keyword_length = 1 },
				{ name = "luasnip" },
				{ name = "buffer",   keyword_length = 3 },
				{ name = "spell",    keyword_length = 3 },
			},
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					ellipsis_char = "…",

					with_text = false,
					maxwidth = 50,
					menu = {
						nvim_lsp = "",
						nvim_lua = "",
						path = "",
						luasnip = "✂",
						buffer = "",
						spell = "",
					},
				}),
			},
		})
	end,
}
