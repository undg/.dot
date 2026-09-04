-- One pair of keys to walk code structure with treesitter.
--
--   g}  next sibling -> nothing left? end of current block -> repeat walks out
--   g{  prev sibling -> nothing left? start of current block -> repeat walks out
--
-- Same key repeats: sibling, sibling, sibling, end of block, then the parent's
-- siblings, and so on. Node type does not matter (statement, function, class,
-- table entry), so there is no separate keymap per node kind.

local api = vim.api

--- Node under the cursor, widened to the outermost node covering the exact
--- same rows. Widening stops at the first parent that spans more rows, so a
--- `block` (which starts on the same row as its first statement) stays the
--- container we walk inside of, not the thing we walk.
--- @return TSNode?
local function anchor_node()
	-- explicit pos on purpose: get_node() with the implicit cursor returns the
	-- root node when the cursor sits on the last column of a line
	local cursor = api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1
	local line = api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
	-- sitting in the indent would resolve to the enclosing block instead of the
	-- statement, so pretend the cursor is on the first non-blank
	local col = math.max(cursor[2], #(line:match("^%s*") or ""))
	local ok, node = pcall(vim.treesitter.get_node, { pos = { row, col } })
	if not ok or not node then
		return
	end

	local n = node
	while true do
		local parent = n:parent()
		if not parent or not parent:parent() then
			break -- keep the root (whole file) out of it
		end
		local nsrow, _, nerow = n:range()
		local psrow, _, perow = parent:range()
		if psrow ~= nsrow or perow ~= nerow then
			break
		end
		n = parent
	end

	return n
end

--- Clamp a 0-indexed (row, col) to something nvim_win_set_cursor accepts.
--- @param row integer
--- @param col integer
local function jump(row, col)
	row = math.max(0, math.min(row, api.nvim_buf_line_count(0) - 1))
	local line = api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
	col = math.max(0, math.min(col, math.max(#line - 1, 0)))
	api.nvim_win_set_cursor(0, { row + 1, col })
end

--- First sibling of `node` sitting on a row past the cursor row. Only this
--- level - climbing to the parent is the block-edge job. Siblings must start on
--- the same column: real peers share indentation, while junk like a function's
--- `parameters` sits on the header row at some random column.
--- @param node TSNode
--- @param row integer cursor row, 0-indexed
--- @param forward boolean
--- @return integer?, integer?
local function sibling_target(node, row, forward)
	local _, anchor_col = node:range()

	--- careful: `forward and a or b` breaks here, a nil sibling flips direction
	--- @param n TSNode
	--- @return TSNode?
	local function next_sib(n)
		if forward then
			return n:next_named_sibling()
		end
		return n:prev_named_sibling()
	end

	local sib = next_sib(node)
	while sib do
		local srow, scol = sib:range()
		if scol == anchor_col then
			if forward and srow > row then
				return srow, scol
			elseif not forward and srow < row then
				return srow, scol
			end
		end
		sib = next_sib(sib)
	end
end

--- Nearest enclosing edge past the cursor row: last line of the block going
--- forward, first line going backward. Starts at `node` itself so a multiline
--- statement gets closed before jumping out of it.
--- @param node TSNode
--- @param row integer cursor row, 0-indexed
--- @param forward boolean
--- @return integer?, integer?
local function block_edge(node, row, forward)
	local n = node --- @type TSNode?
	while n do
		local srow, scol, erow, ecol = n:range()
		if not forward then
			if srow < row then
				return srow, scol
			end
		else
			-- end col 0 means the node stops at the start of erow, so the last
			-- line holding content is the one above it
			if ecol == 0 then
				erow, ecol = erow - 1, math.huge
			else
				ecol = ecol - 1
			end
			if erow > row then
				return erow, ecol
			end
		end
		n = n:parent()
	end
end

--- Nearest child of `node` past the cursor row. Used when the cursor is on a
--- row the anchor only contains (blank line, line with a lone brace), so the
--- anchor is a container and not a thing to walk away from.
--- @param node TSNode
--- @param row integer cursor row, 0-indexed
--- @param forward boolean
--- @return integer?, integer?
local function child_target(node, row, forward)
	local trow, tcol
	for child in node:iter_children() do
		if child:named() then
			local srow, scol = child:range()
			if forward and srow > row then
				return srow, scol -- children are ordered, first hit wins
			elseif not forward and srow < row then
				trow, tcol = srow, scol -- keep the last one before the cursor
			end
		end
	end
	return trow, tcol
end

--- @param forward boolean
local function step(forward)
	local row = api.nvim_win_get_cursor(0)[1] - 1
	local node = anchor_node()
	if not node then
		return
	end

	local nsrow, _, nerow = node:range()
	if nsrow < row and row < nerow then
		local crow, ccol = child_target(node, row, forward)
		if crow then
			jump(crow, ccol)
			return
		end
	end

	local trow, tcol = sibling_target(node, row, forward)
	if not trow then
		trow, tcol = block_edge(node, row, forward)
	end
	if trow then
		jump(trow, tcol)
	end
end

local M = {}

--- @param forward boolean
local function walk(forward)
	return function()
		-- current position goes to the jumplist. no spaces around the keys:
		-- `normal!` would run a trailing space as a real keypress
		vim.cmd("normal! m'")
		for _ = 1, vim.v.count1 do
			step(forward)
		end
	end
end

M.next = walk(true)
M.prev = walk(false)

local next_opt = { silent = true, desc = "(treesitter) next sibling / end of block" }
local prev_opt = { silent = true, desc = "(treesitter) prev sibling / start of block" }

Keymap.normal("}", M.next, next_opt)
Keymap.normal("{", M.prev, prev_opt)
Keymap.xisual("}", M.next, next_opt)
Keymap.xisual("{", M.prev, prev_opt)

-- old paragraph motions move one key over. operator pending mode is untouched,
-- so `d}` and `y{` still work on paragraphs
Keymap.normal("g}", "}", { silent = true, desc = "next paragraph" })
Keymap.normal("g{", "{", { silent = true, desc = "prev paragraph" })
Keymap.xisual("g}", "}", { silent = true, desc = "next paragraph" })
Keymap.xisual("g{", "{", { silent = true, desc = "prev paragraph" })

return M
