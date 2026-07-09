vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#1e3a5f" })
vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#7dd3fc", bold = true })

vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#254a70" })
vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#a8d8ea", bold = true })

vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#2c5a80" })
vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#b8e6f0", bold = true })

vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#336a90" })
vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#c8eef5", bold = true })

vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#3a7aa0" })
vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#d8f0f8", bold = true })

vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#3a7aa0" })
vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#d8f0f8", bold = true })

vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#7dd3fc", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#7dd3fc" })

return {
	"MeanderingProgrammer/render-markdown.nvim",                                      -- https://github.com/MeanderingProgrammer/render-markdown.nvim
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		heading = {
			-- backgrounds = {
			-- 	"RenderMarkdownH1Bg",
			-- 	"RenderMarkdownH2Bg",
			-- 	"RenderMarkdownH3Bg",
			-- 	"RenderMarkdownH4Bg",
			-- 	"RenderMarkdownH5Bg",
			-- 	"RenderMarkdownH6Bg",
			-- },
			-- foregrounds = {
			-- 	"RenderMarkdownH1",
			-- 	"RenderMarkdownH2",
			-- 	"RenderMarkdownH3",
			-- 	"RenderMarkdownH4",
			-- 	"RenderMarkdownH5",
			-- 	"RenderMarkdownH6",
			-- },
			icons = { "󰎥 ", "󰎨 ", "󰎫 ", "󰎲 ", "󰎯 ", "󰎵 " },
			-- border = true,
			-- border_virtual = true,
			-- right_pad = 1,
			left_pad = 1,
			-- width = "block",
		},
		file_types = { "markdown" },
		-- new conf START
		render_modes = { --
			"n",
			-- "i",
			-- "v",
			-- "V",
			"c",
			"t",
		},
		anti_conceal = { enabled = false },
		win_options = {
			concealcursor = { rendered = "n" },
		},
		bullet = {
			right_pad = 1,
		},
		code = {
			width = "block",
			right_pad = 4,
			min_width = 10,
		},
		checkbox = {
			enabled = true,
			render_modes = false,
			bullet = false,
			left_pad = 1,
			right_pad = 1,
			unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked", scope_highlight = nil },
			checked = { icon = "✔ ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
			},
			scope_priority = nil,
		},
	},

	ft = { "markdown" },
}
