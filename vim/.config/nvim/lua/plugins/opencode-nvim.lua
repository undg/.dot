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
		local opencode_ok, opencode = pcall(require, "which-key")

		local not_ok = not wk_ok and "which-key" --
			or not opencode_ok and "opencode"
			or false

		if not_ok then
			vim.notify("plugins/opencode.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		wk.add({
			{ "<leader>o", group = "Obsidian", silent = false },
		})

		wk.add({
			mode = { "n", "x" },
			{ "<leader>oo", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "(opencode 🤖) Ask question" },
			{ "<leader>oa", function() require("opencode").select() end, desc = "(opencode 🤖) Select an action" },
			{ "<leader>op", function() require("opencode").prompt("@this") end, desc = "(opencode 🤖) Add/Paste to opencoode" },
		})

		wk.add({
			mode = { "n", "t" },
			{ "<leader>ot", function() require("opencode").toggle() end, desc = "(opencode) Toggle sidebar" },
		})

		-- Recommended/examplein those keybindings keymaps.
		Keymap.normal("<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
			{ desc = "Ask opencode" })
		Keymap.xisual("<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
			{ desc = "Ask opencode" })

		Keymap.normal("<C-x>", function() require("opencode").select() end, { desc = "Execute opencode action…" })
		Keymap.xisual("<C-x>", function() require("opencode").select() end, { desc = "Execute opencode action…" })

		Keymap.normal("ga", function() require("opencode").prompt("@this") end, { desc = "Add to opencode" })
		Keymap.xisual("ga", function() require("opencode").prompt("@this") end, { desc = "Add to opencode" })

		Keymap.normal("<leader>ao", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
		vim.keymap.set("t", "<leader>ao", function() require("opencode").toggle() end, { desc = "Toggle opencode" }) -- terminal mode not supported by Keymap util

		Keymap.normal("<S-C-u>", function() require("opencode").command("session.half.page.up") end,
			{ desc = "opencode half page up" })
		Keymap.normal("<S-C-d>", function() require("opencode").command("session.half.page.down") end,
			{ desc = "opencode half page down" })

		-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
	end,
}
