local M = {}

-- Concurrent-key pool, closest to home row first. Uppercase because these
-- are global (file) marks in vim -- lowercase marks are buffer-local, so a
-- single pool tracked across buffers would collide with vim's own state.
-- Fixed size so grug always know max number of live marks. When pool runs
-- out, oldest mark evicted (LRU) and its letter reused.
local POOL = {
	"Z", "X", "C", "V", "B",
	"H", "J", "K", "L",
	"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
	"N", "M",
}

---@type { letter: string, buf: integer, line: integer }[]
local assigned = {}

local function find_index(buf, line)
	for i, entry in ipairs(assigned) do
		if entry.buf == buf and entry.line == line then
			return i
		end
	end
	return nil
end

local function free_letter()
	for _, letter in ipairs(POOL) do
		local taken = false
		for _, entry in ipairs(assigned) do
			if entry.letter == letter then
				taken = true
				break
			end
		end
		if not taken then
			return letter
		end
	end
	return nil
end

---Assign (or reuse) a mark letter for buf:line. Returns the letter used.
---@param buf integer
---@param line integer
---@return string
function M.assign(buf, line)
	local existing_index = find_index(buf, line)
	if existing_index then
		local entry = table.remove(assigned, existing_index)
		table.insert(assigned, entry)
		return entry.letter
	end

	local letter = free_letter()
	if not letter then
		local evicted = table.remove(assigned, 1)
		letter = evicted.letter
	end

	vim.api.nvim_buf_set_mark(buf, letter, line, 0, {})
	table.insert(assigned, { letter = letter, buf = buf, line = line })
	return letter
end

---Remove the mark at buf:line, if one was assigned there.
---@param buf integer
---@param line integer
function M.remove(buf, line)
	local index = find_index(buf, line)
	if not index then
		return
	end
	local entry = table.remove(assigned, index)
	vim.api.nvim_buf_del_mark(buf, entry.letter)
end

---Remove every mark assigned in buf.
---@param buf integer
function M.remove_buf(buf)
	for i = #assigned, 1, -1 do
		local entry = assigned[i]
		if entry.buf == buf then
			vim.api.nvim_buf_del_mark(buf, entry.letter)
			table.remove(assigned, i)
		end
	end
end

return M
