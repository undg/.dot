local colors = require("custom.colors")

-- Dynamically extracts the color word (must start with a capital letter) from mock_line,
-- simulating the word under the cursor. Surrounding text should not be capitalized.
local function extract_color_word(line)
	return line:match("%u%l+")
end

-- mock original colors, capitalized, order matter
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
			expand = function()
				return extract_color_word(mock_line)
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
		colors.next()
		assert.equals(mock_line, "text Green text")
		colors.next()
		assert.equals(mock_line, "text Indigo text")
		colors.next()
		assert.equals(mock_line, "text Blue text")
	end)

	it("should cycle to previous color", function()
		colors.prev()
		assert.equals(mock_line, "text Indigo text")
		colors.prev()
		assert.equals(mock_line, "text Green text")
		colors.prev()
		assert.equals(mock_line, "text Blue text")
	end)

	it("should handle case when no color is under the cursor", function()
		mock_line = "text noColorHere text"
		colors.next()
		assert.equals(mock_line, "text noColorHere text")
	end)

	it("should go to specific color", function()
		colors.go_by(1)()
		assert.equals(mock_line, "text Green text")
	end)
	it("should go to specific color", function()
		colors.go_by(2)()
		assert.equals(mock_line, "text Indigo text")
	end)
	it("should go to specific color", function()
		colors.go_by(3)()
		assert.equals(mock_line, "text Blue text")
	end)
end)
