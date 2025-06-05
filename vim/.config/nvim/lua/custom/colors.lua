-- white black
local M = {}

M.colors = {
	-- dark
	"Black",
	"Navy",
	"Green",
	"Olive",
	"Blue",
	"Indigo",
	"Red",
	"Maroon",
	"Magenta",

	-- light
	"White",
	"Orange",
	"LimeGreen",
	"Yellow",
	"Tomato",
	"Bisque",
	"Aqua",
	"Khaki",
	"Gray",
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

function M.cycle(direction)
	local word, currentIndex = M.getCurrent()

	local newColor

	if not currentIndex then
		return
	end

	if direction == "next" then
		newColor = M.colors[currentIndex + 1] or M.colors[1]
	else
		newColor = M.colors[currentIndex - 1] or M.colors[#M.colors]
	end

	local line = vim.api.nvim_get_current_line()
	local cursor_col = vim.fn.col(".")
	local search_pos = vim.fn.searchpos(word, "bcn", vim.fn.line("."))
	local search_col = search_pos[2]
	local start_col = search_col - 1
	local end_col = search_col + #word - 1

	-- Only replace if cursor is within word bounds
	if start_col < cursor_col and cursor_col <= end_col then
		local before = line:sub(1, start_col)
		local after = line:sub(end_col + 1)
		vim.api.nvim_set_current_line(before .. newColor .. after)
		-- Move cursor to the beginning or word
		vim.api.nvim_win_set_cursor(0, { search_pos[1], start_col })
	end
end

-- Get next color from colors list
function M.next()
	M.cycle("next")
end

-- Get prev color from colors list
function M.prev()
	M.cycle("prev")
end

return M
