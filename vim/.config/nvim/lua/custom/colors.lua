-- white black
local M = {}

M.colors = {
	-- dark
	"Black", "Navy", "Green", "Blue", "Indigo", "Red", "Olive", "Maroon", "Magenta",
	-- light
	"White", "Orange", "LimeGreen", "Yellow", "Tomato", "Bisque", "Aqua", "Khaki", "Gray",
}

function M.getCurrent()
	local word = vim.fn.expand("<cWORD>")
	word = word:gsub("[\"`'](.*)[\"`']", "%1") -- strip quotes
	word = word:gsub("[,;()[{}]", "")       -- strip common characters that may be next to cWORD
	word = word:gsub("]", "")               -- strip it separately, as it's hard to escape

	local index

	for i, color in ipairs(M.colors) do
		if color:lower() == word:lower() then
			index = i
		end
	end

	return word, index
end

--- Cycles the color word under the cursor by a given offset.
---Replaces the current color word with a new one from M.colors, offset by n.
---Moves the cursor to the start of the replaced word.
---Does nothing if no color word is found under the cursor.
---@param n integer Offset to cycle by (positive or negative)
function M.cycle_by(n)
	local word, currentIndex = M.getCurrent()
	if not currentIndex then return end
	local total = #M.colors
	local newIndex = ((currentIndex - 1 + n) % total) + 1
	local newColor = M.colors[newIndex]

	local line = vim.api.nvim_get_current_line()
	local cursor_col = vim.fn.col(".")
	local search_pos = vim.fn.searchpos(word, "bcn", vim.fn.line("."))
	local search_col = search_pos[2]
	local start_col = search_col - 1
	local end_col = search_col + #word - 1

	if start_col < cursor_col and cursor_col <= end_col then
		local before = line:sub(1, start_col)
		local after = line:sub(end_col + 1)
		vim.api.nvim_set_current_line(before .. newColor .. after)
		vim.api.nvim_win_set_cursor(0, { search_pos[1], start_col })
	end
end

-- Get next color from colors list
function M.next()
	M.cycle_by(1)
end

-- Get prev color from colors list
function M.prev()
	M.cycle_by(-1)
end

---Moves to the next color in the palette by n steps.
---@param n integer Number of steps to move forward in the color list.
---@return fun():nil Closure to execute the color change, replacing the color under cursor.
function M.go_by(n)
	return function()
		M.cycle_by(n)
	end
end

return M
