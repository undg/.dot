local paste = require("custom.paste-prefixed-buf-to-copilot")

describe("paste-prefixed-buf-to-copilot", function()
	describe("get_files_from_harpoon", function()
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
			local paste_from_harpoon = paste.get_files_from_harpoon()

			assert.are.same({
				"> ##buffer:file1.lua",
				"> ##buffer:file2.htm",
			}, paste_from_harpoon)
		end)
	end)

	describe("get_files_from_register_lines", function()
		it("should extract files from register lines", function()
			-- Put test data in " register
			vim.fn.setreg('"', {
				"/home/user/test.lua",
				"/home/user/other.py",
			})

			local files = paste.get_files_from_register_lines('"')

			assert.are.same({
				"> ##buffer:/home/user/test.lua",
				"> ##buffer:/home/user/other.py",
			}, files)
		end)

		-- it("should handle empty register", function()
		-- 	vim.fn.setreg('"', "")
		-- 	local files = M.get_files_from_register_lines('"')
		-- 	assert.are.equal(0, #files)
		-- end)

		-- it("should handle register with no file markers", function()
		-- 	vim.fn.setreg('"', {
		-- 		"just some text",
		-- 		"no file markers here",
		-- 	})
		-- 	local files = M.get_files_from_register_lines('"')
		-- 	assert.are.equal(0, #files)
		-- end)
	end)
end)
