return {
	"folke/todo-comments.nvim", -- https://github.com/folke/todo-comments.nvim?tab=readme-ov-file
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		keywords = {
			TODO = { icon = " ", color = "warning" },
			-- 	['@TODO (Bartek Laskowski)'] = { icon = "⚠", color = "error", alt = "no TODO's leftover" },
			-- 	['@TODO (undg)'] = { icon = "⚠", color = "error", alt = "no TODO's leftover" },
		},
		highlight = {
			pattern = {
				[[.*<(KEYWORDS)\s*:]],
				[[.*<(KEYWORDS).*:]],
			}, -- pattern or table of patterns, used for highlighting (vim regex)
		}
	}
}
-- examples
-- TODO: with nothing else
-- TODO (Bartek Laskowski) 2025-04-03: with monkey
-- @TODO (Bartek Laskowski) 2025-04-03: no monkey here
-- @TODO (undg) 2025-04-03: no monkey here
