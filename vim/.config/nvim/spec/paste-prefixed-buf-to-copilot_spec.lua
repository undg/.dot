local paste = require("custom.paste-prefixed-buf-to-copilot")
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

		assert.are.same({ "> ##buffer:file1.lua", "> ##buffer:file2.htm" }, paste_from_harpoon)
	end)
end)
