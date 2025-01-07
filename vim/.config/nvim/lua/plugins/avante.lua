return {
	"yetone/avante.nvim", -- https://github.com/yetone/avante.nvim
	event = "VeryLazy",
	version = false,
	build = "make",
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		provider = "deepseek",
		vendors = {
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com",
				model = "deepseek-coder",
			},
			ollama = {
				__inherited_from = "openai",
				endpoint = "http://localhost:11434/v1",
				api_key_name = "",
				model = "llama3.2:latest",
			},
			["claude-sonet"] = {
				__inherited_from = "openai",
				api_key_name = "ANTHROPIC_API_KEY",
				endpoint = "https://api.anthropic.com/v1/messages",
				model = "claude-3-5-sonnet-latest",
			},
		},
	},
}
