return {
	"NickvanDyke/opencode.nvim", -- https://github.com/NickvanDyke/opencode.nvim
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		-- Required for `snacks` provider.
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{
			"folke/snacks.nvim", -- https://github.com/folke/snacks.nvim
			opts = { input = {}, picker = {}, terminal = {} }
		}
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

		local wk_ok, wk = pcall(require, "which-key")
		local opencode_ok, opencode = pcall(require, "opencode")

		local not_ok = not wk_ok and "which-key" --
			or not opencode_ok and "opencode"
			or false

		if not_ok then
			vim.notify("plugins/opencode.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		wk.add({
			mode = { "n", "x" },
			{ "<leader>oo", function() opencode.ask("@this: ", { submit = true }) end, desc = "(opencode 🤖) Ask question" },
			{ "<leader>oa", function() opencode.select() end, desc = "(opencode 🤖) Select an action" },
			{ "<leader>op", function() opencode.prompt("@this") end, desc = "(opencode 🤖) Add/Paste to opencode" },
		})

		wk.add({
			mode = { "n", "t" },
			{ "<leader>ot", function() opencode.toggle() end, desc = "(opencode) Toggle sidebar" },
		})

		wk.add({
			{ "<leader>o", group = "OpenCode", silent = false },
			{ "<leader>oK", function() opencode.command("session.half.page.up") end, desc = "(opencode 🤖) Scroll window half page up" },
			{ "<leader>oJ", function() opencode.command("session.half.page.down") end, desc = "(opencode 🤖) Scroll window half page down" },
			{ "<leader>ok", function() opencode.command("session.page.up") end, desc = "(opencode 🤖) Scroll window half page up" },
			{ "<leader>oj", function() opencode.command("session.page.down") end, desc = "(opencode 🤖) Scroll window half page down" },
			{ "<leader>ogg", function() opencode.command("session.first") end, desc = "(opencode 🤖) Scroll to first message" },
			{ "<leader>oG", function() opencode.command("session.last") end, desc = "(opencode 🤖) Scroll to last message" },
			{ "<leader>oc", function() opencode.command("session.compact") end, desc = "(opencode 🤖) Make compact summary" },
			{ "<leader>ou", function() opencode.command("session.undo") end, desc = "(opencode 🤖) Undo message" },
			{ "<leader>or", function() opencode.command("session.redo") end, desc = "(opencode 🤖) Redo message" },
			{ "<leader>on", function() opencode.command("session.new") end, desc = "(opencode 🤖) New session" },
			{ "<leader>oi", function() opencode.command("session.interrupt") end, desc = "(opencode 🤖) Interrupt session" },
		})
	end,
}
