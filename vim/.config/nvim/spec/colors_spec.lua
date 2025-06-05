local colors = require("custom.colors")
-- mock original colors
colors.colors = {
	"Indigo", -- 1
	"Blue", -- 2
	"Green", -- 3
}

describe("Color Cycling", function()
	local mock_line = "text Blue text"
	local old_fn = vim.fn
	local old_api = vim.api

	before_each(function()
		vim.fn = {
			-- Dynamically extracts the color word (must start with a capital letter) from mock_line,
			-- simulating the word under the cursor. Surrounding text should not be capitalized.
			expand = function()
				return mock_line:match("%u%l+")
			end,
			col = function()
				return 6
			end,
			line = function()
				return 1
			end,
			searchpos = function()
				return { 1, 6 }
			end,
		}
		vim.api = {
			nvim_get_current_line = function()
				return mock_line
			end,
			nvim_set_current_line = function(line)
				mock_line = line
			end,
			nvim_win_set_cursor = function() end,
		}
		-- Reset mock_line before each test
		mock_line = "text Blue text"
	end)

	after_each(function()
		vim.fn = old_fn
		vim.api = old_api
	end)

	it("should get current color", function()
		local word, index = colors.getCurrent()
		assert.equals(word, "Blue")
		assert.equals(index, 2)
	end)

	it("should cycle to next color", function()
		colors.cycle("next")
		assert.equals(mock_line, "text Green text")
		colors.cycle("next")
		assert.equals(mock_line, "text Indigo text")
		colors.cycle("next")
		assert.equals(mock_line, "text Blue text")
	end)

	it("should cycle to previous color", function()
		colors.cycle("prev")
		assert.equals(mock_line, "text Indigo text")
		colors.cycle("prev")
		assert.equals(mock_line, "text Green text")
		colors.cycle("prev")
		assert.equals(mock_line, "text Blue text")
	end)
end)
