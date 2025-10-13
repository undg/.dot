local paste = require("custom.paste-prefixed-buf-to-copilot")

describe("paste-prefixed-buf-to-copilot", function()
	describe("[HARPOON] get_files_from_harpoon", function()
		local old_harpoon

		before_each(function()
			-- Mock harpoon
			old_harpoon = package.loaded["harpoon"]
			package.loaded["harpoon"] = {
				get_mark_config = function()
					return {
						marks = {
							{ filename = "file1.lua" },
							{ filename = "file2.htm" },
						},
					}
				end,
			}
		end)

		after_each(function()
			package.loaded["harpoon"] = old_harpoon
		end)

		it("should return prefixed files", function()
			local files = paste.get_files_from_harpoon()
			local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))


			assert.are.same({
				"> ##buffer:" .. config_dir .. "file1.lua",
				"> ##buffer:" .. config_dir .. "file2.htm",
			}, files)
		end)
	end)

	describe("[PASTE] get_files_from_register_lines", function()
		it("should extract files from register lines", function()
			-- Put clean data in " register
			vim.fn.setreg('"', {
				"init.lua", -- need to be real file
				"README.md", -- need to be real file
			})

			local files = paste.get_files_from_register_lines('"')
			local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))

			assert.are.same({
				"> ##buffer:" .. config_dir .. "init.lua",
				"> ##buffer:" .. config_dir .. "README.md",
			}, files)
		end)

		it("should handle empty register", function()
			vim.fn.setreg('"', "")
			local files = paste.get_files_from_register_lines('"')
			local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))

			assert.are.same({}, files)
		end)

		it("should handle register with empty lines", function()
			vim.fn.setreg('"', {
				"init.lua", -- need to be real file
				"",
				"README.md", -- need to be real file
				"",
			})
			local files = paste.get_files_from_register_lines('"')
			local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))

			assert.are.same({
				"> ##buffer:" .. config_dir .. "init.lua",
				"> ##buffer:" .. config_dir .. "README.md",
			}, files)
		end)

		it("should filter only file names", function()
			vim.fn.setreg('"', {
				"init.lua", -- need to be real file
				"adfasdf a asdf adsf",
				"README.md", -- need to be real file
				"fn(/home/user/other.py)",
			})
			local files = paste.get_files_from_register_lines('"')
			local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))


			assert.are.same({
				"> ##buffer:" .. config_dir .. "init.lua",
				"> ##buffer:" .. config_dir .. "README.md",
			}, files)
		end)
	end)
end)
