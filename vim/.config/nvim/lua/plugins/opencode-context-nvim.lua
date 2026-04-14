return {
	"cousine/opencode-context.nvim", -- https://github.com/cousine/opencode-context.nvim
	opts = {
		tmux_target = nil,        -- Manual override: "session:window.pane"
		auto_detect_pane = true,  -- Auto-detect opencode pane in current window
	},
	keys = {
		{ "<leader>oc", "<cmd>OpencodeSend<cr>",       desc = "Send prompt to opencode" },
		{
			"<leader>oc",
			"<cmd>OpencodeSend<cr>",
			mode = "v",
			desc = "(opencode-context) Send prompt",
		},
		{ "<leader>ot", "<cmd>OpencodeSwitchMode<cr>", desc = "(opencode-context) Toggle mode" },
		{ "<leader>op", "<cmd>OpencodePrompt<cr>",     desc = "(opencode-context) Open persistent prompt" },
	},
	cmd = { "OpencodeSend", "OpencodeSwitchMode", "OpencodePrompt" },
}
