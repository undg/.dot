return {
	"nvim-neotest/neotest", -- https://github.com/nvim-neotest/neotest?tab=readme-ov-file
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- testing framework adapters -- https://github.com/nvim-neotest/neotest?tab=readme-ov-file#supported-runners
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-go", -- https://github.com/nvim-neotest/neotest-go
	},
	config = function()
		local neotest = require("neotest")

		---@type neotest.Config?
		---@diagnostic disable-next-line: missing-fields
		local config = {
			quickfix = {
				enabled = false,
				open = false,
			},
			output = {
				enabled = true,
				open_on_run = false,
			},
			floating = {
				border = "rounded",
			},
			adapters = {
				require("neotest-vitest")({
					-- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
				}),
				require("neotest-python")({
					runner = "pytest",
					args = { "-vv" },
				}),
				require("neotest-go")({
					recursive_run = true,
					experimental = {
						test_table = true,
					},
					args = { "-count=1", "-timeout=60s" },
				}),
			},
		}
		neotest.setup(config)

		-- WORKAROUND: neotest subprocess doesn't source nvim-treesitter's
		-- plugin/filetypes.lua, so tree-sitter language->filetype mappings
		-- (tsx->typescriptreact, javascript->javascriptreact, etc.) are
		-- missing in the subprocess.  Without them, discover_positions()
		-- fails for .tsx/.jsx files:
		--   No parser for language "typescriptreact"
		--
		-- Root cause: subprocess starts with `-u NONE` and builds its
		-- runtimepath from neotest + nio + adapter roots + raw parser
		-- .so dirs.  nvim-treesitter's plugin root is never added, so
		-- its plugin/filetypes.lua is never sourced when the subprocess
		-- runs `runtime! plugin/filetypes.lua`.
		--
		-- .ts files work by accident (filetype "typescript" matches
		-- parser name "typescript" directly).
		--
		-- This wraps subprocess.init to prepend nvim-treesitter's root
		-- to the child's runtimepath and re-source plugin/filetypes.lua
		-- after every subprocess spawn.
		--
		-- Tracked at: https://github.com/nvim-neotest/neotest/issues/??
		local subprocess = require("neotest.lib.subprocess")
		local _init = subprocess.init
		subprocess.init = function()
			_init()
			local ok, nvim_ts = pcall(require, "nvim-treesitter")
			if ok and subprocess.enabled() then
				local ts_root = subprocess.resolve_plugin_root(nvim_ts.setup)
				if ts_root then
					subprocess.request("nvim_exec_lua", string.format([[
						vim.opt.runtimepath:prepend("%s")
						vim.cmd("runtime! plugin/filetypes.lua")
					]], ts_root), {})
				end
			end
		end

		Keymap.normal("tt", "", { desc = "neotest" })
		Keymap.normal("ttr", function()
			neotest.run.run()
		end, { desc = "(neotest) run narest test" })
		Keymap.normal("ttf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "(neotest) run the curent file" })
		Keymap.normal("ttw", function()
			neotest.watch.toggle()
		end, { desc = "(neotest) toggle watch" })
		Keymap.normal("tts", function()
			neotest.run.stop()
		end, { desc = "(neotest) stop narest test" })
		Keymap.normal("ttl", function()
			neotest.run.run_last()
		end, { desc = "(neotest) run last test" })
		Keymap.normal("tto", ":Neotest output<cr>", { desc = "(neotest) toggle output" })
		Keymap.normal("ttO", function()
			neotest.output_panel.toggle()
		end, { desc = "(neotest) toggle output panel" })
		Keymap.normal("ttt", function()
			neotest.summary.toggle()
		end, { desc = "(neotest) toggle summary" })
		Keymap.normal("ttj", ":Neotest jump next<cr>", { desc = "(neotest) jump next" })

		Keymap.normal("ttk", ":Neotest jump prev<cr>", { desc = "(neotest) jump prev" })
		Keymap.normal("ttn", function()
			neotest.jump.next({ status = "failed" })
		end, { desc = "(neotest) jump next failed" })
		Keymap.normal("ttp", function()
			neotest.jump.prev({ status = "failed" })
		end, { desc = "(neotest) jump prev failed" })
	end,
}
