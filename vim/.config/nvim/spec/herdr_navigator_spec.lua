describe("herdr lazygit terminal navigation", function()
	local original_keymap
	local original_stopinsert
	local original_herdr_navigation
	local original_herdr_navigator
	local original_plugin
	local mappings
	local navigated_direction
	local fallback_called
	local stopped_insert

	before_each(function()
		original_keymap = Keymap
		original_stopinsert = vim.cmd.stopinsert
		original_herdr_navigation = package.loaded["custom.lazygit-nav.herdr"]
		original_herdr_navigator = package.loaded["herdr-navigator"]
		original_plugin = package.loaded["plugins.herdr-navigator-nvim"]
		mappings = {}
		navigated_direction = nil
		fallback_called = false
		stopped_insert = false

		Keymap = {
			terminal = function(key, callback)
				mappings[key] = callback
			end,
		}
		vim.cmd.stopinsert = function()
			stopped_insert = true
		end
		package.loaded["custom.lazygit-nav.herdr"] = {
			is_window = function()
				return true
			end,
			navigate = function(direction)
				navigated_direction = direction
			end,
		}
		package.loaded["herdr-navigator"] = {
			setup = function() end,
			navigate_terminal = function()
				fallback_called = true
			end,
		}
		package.loaded["plugins.herdr-navigator-nvim"] = nil
	end)

	after_each(function()
		Keymap = original_keymap
		vim.cmd.stopinsert = original_stopinsert
		package.loaded["custom.lazygit-nav.herdr"] = original_herdr_navigation
		package.loaded["herdr-navigator"] = original_herdr_navigator
		package.loaded["plugins.herdr-navigator-nvim"] = original_plugin
	end)

	it("keeps lazygit in terminal-insert mode while handing navigation to herdr", function()
		local plugin = require("plugins.herdr-navigator-nvim")
		plugin.config()

		mappings["<M-h>"]()

		assert.are.equal("left", navigated_direction)
		assert.is_false(fallback_called)
		assert.is_false(stopped_insert)
	end)
end)
