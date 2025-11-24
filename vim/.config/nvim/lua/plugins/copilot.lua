-- https://github.com/settings/copilot/features
local default_model =
-- "claude-3.5-sonnet"
-- "claude-3.7-sonnet"
-- "claude-3.7-sonnet-thought" -- slow
"claude-sonnet-4.5"

-- "gemini-2.0-flash-001"
-- "gemini-2.5-pro" -- slow AF

-- "gpt-4.1"
-- "gpt-4o"
-- "gpt-5" -- slow AF
-- "o3-mini"
-- "o4-mini"

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",          -- https://github.com/CopilotC-Nvim/CopilotChat.nvim
		dependencies = {
			{ "zbirenbaum/copilot.lua" },          -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken",                   -- Only on MacOS or Linux
		config = function()
			local prompt = require("plugins.copilot-prompts")
			local util = require("plugins.copilot-util")

			local chat = require("CopilotChat")
			chat.setup({
				resource_processing = true,
				history_path = "~/Dropbox/DropsyncFiles/Work/gpt-chats", -- @TODO (undg) 2025-08-11: think about better path. This one is misleading.
				callback = function(res)
					util.copilot_callback(res)
				end,
				model = default_model,
				question_header = "# HUMAN ",     -- Header to use for user questions
				answer_header = "# GRUG ",        -- Header to use for AI answers
				error_header = "# KURWA MAC!!!   #$%&@^*$@ ", -- Header to use for errors
				system_prompt = prompt.system_prompt, -- System prompt to use (can be specified manually in prompt via /).
				prompts = prompt.prompts,         -- User defined prompts
				headers = {
					user = "👤 HUMAN",
					assistant = "🤖 GRUG",
					tool = "🔧 Tool",
				},
				mappings = {
					toggle_sticky = { normal = "gs" },
				},
				sticky = { "#buffer", "#diagnostics", "@copilot" }, -- Always include buffer and diagnostics in new chats
				separator = "━━",
				auto_fold = false,                      -- Automatically folds non-assistant messages
			})

			Keymap.normal("<leader>aa", chat.toggle, { desc = "(CopilotChat) open chat window" })
			Keymap.visual("<leader>aa", chat.open, { desc = "(CopilotChat) open chat window" })

			Keymap.normal("<leader>ad", ":CopilotChatDoc<CR>", { desc = "(CopilotChat) generate documentation" })
			Keymap.visual("<leader>ad", ":CopilotChatDoc<CR>", { desc = "(CopilotChat) generate documentation" })

			Keymap.normal("<leader>ar", ":CopilotChatReview<CR>", { desc = "(CopilotChat) code review" })
			Keymap.visual("<leader>ar", ":CopilotChatReview<CR>", { desc = "(CopilotChat) code review" })

			Keymap.normal("<leader>at", ":CopilotChatTest<CR>", { desc = "(CopilotChat) generate tests" })
			Keymap.visual("<leader>at", ":CopilotChatTest<CR>", { desc = "(CopilotChat) generate tests" })

			Keymap.normal("<leader>ax", util.reset_title, { desc = "(CopilotChat) reset chat title" })
			Keymap.normal("<leader>at", util.show_title, { desc = "(CopilotChat) show chat title" })
		end,
	},
	{
		"ravitemer/mcphub.nvim", -- https://ravitemer.github.io/mcphub.nvim/
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup({
				extensions = {
					copilotchat = {
						enabled = true,
						convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
						convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
						add_mcp_prefix = false, -- Add "mcp_" prefix to function names
					},
				},
			})
			require("mcp.help_server")
		end,
	},
	{

		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	},
}
