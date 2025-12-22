return {
	"MeanderingProgrammer/render-markdown.nvim",                                      -- https://github.com/MeanderingProgrammer/render-markdown.nvim
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		heading = {
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH6Bg",
			},
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH5",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH2",
				"RenderMarkdownH6",
			},
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			border = true,
			border_virtual = true,
			right_pad = 3,
			left_pad = 3,
			width = "block",
		},
		file_types = { "markdown", "Avante" },
		-- new conf START
		render_modes = { --
			"n",
			-- "i",
			"v",
			"V",
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
	},

	ft = { "markdown" },
}
