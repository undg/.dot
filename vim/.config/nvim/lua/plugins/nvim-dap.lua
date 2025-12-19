return {
	{
		"mfussenegger/nvim-dap",
		-- depencendies = {
		-- 	'mxsdev/nvim-dap-vscode-js',
		-- },
		config = function()
			local dap = require("dap")

			-- require("dap-vscode-js").setup({
			-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
			-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug",                                         -- Path to vscode-js-debug installation.
			-- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
			-- adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- which adapters to register in nvim-dap
			-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
			-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
			-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			-- })

			Keymap.normal('<leader>dc', require 'dap'.continue)
			Keymap.normal("<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
			Keymap.normal('<leader>do', require 'dap'.step_over)
			Keymap.normal('<leader>di', require 'dap'.step_into)
			Keymap.normal('<leader>dO', require 'dap'.step_out)
			Keymap.normal('<leader>db', require 'dap'.toggle_breakpoint)
			Keymap.normal('<leader>dB',
				function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		config = true,
		keys = {
			{
				"<leader>dd",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI"
			},
		},
		dependencies = {
			-- keep-sorted start block=yes
			{
				"jay-babu/mason-nvim-dap.nvim",
				---@type MasonNvimDapSettings
				opts = {
					-- This line is essential to making automatic installation work
					-- :exploding-brain
					handlers = {},
					automatic_installation = false,
					-- DAP servers: these will be installed by mason-tool-installer.nvim
					-- for consistency.
					ensure_installed = {},
				},
				dependencies = {
					"mfussenegger/nvim-dap",
					"mason-org/mason.nvim",
				},
			}
		}
	}

}
