local M = {}

---@class MarkdownMarker
---@field bufnr integer
---@field row integer Zero-based row.
---@field start_col integer
---@field end_col integer
---@field text string

---@class MarkdownContext
---@field in_code boolean
---@field link? string
---@field task? MarkdownMarker
---@field heading? MarkdownMarker

local function marker(node, bufnr)
	local row, start_col, _, end_col = node:range()
	local text = vim.treesitter.get_node_text(node, bufnr)
	-- Heading marker nodes can include the line's leading indentation.
	local indent = text:match("^%s*")
	return {
		bufnr = bufnr,
		row = row,
		start_col = start_col + #indent,
		end_col = end_col,
		text = text:sub(#indent + 1),
	}
end

local function bare_url(line, col)
	local start = 1
	while true do
		local first, last = line:find("[hH][tT][tT][pP][sS]?://[^%s<>]+", start)
		if not first then
			return nil
		end

		local url = line:sub(first, last):gsub("[.,;:!?]+$", "")
		-- Sentence punctuation is not part of a URL; balanced URL parentheses are.
		while url:sub(-1) == ")" or url:sub(-1) == "]" do
			local closing = url:sub(-1)
			local opening = closing == ")" and "(" or "["
			local _, opens = url:gsub(vim.pesc(opening), "")
			local _, closes = url:gsub(vim.pesc(closing), "")
			if closes <= opens then
				break
			end
			url = url:sub(1, -2)
		end
		if col >= first - 1 and col < first - 1 + #url then
			return url
		end
		start = last + 1
	end
end

---Read source syntax, independent of rendered/concealed screen columns.
---@return MarkdownContext
function M.read()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]
	local current = { in_code = false }
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	if not ok then
		vim.notify_once("Markdown actions require the markdown Tree-sitter parser", vim.log.levels.WARN)
		return current
	end

	parser:parse(true)
	local block = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, col }, ignore_injections = true })
	local node = block
	while node do
		local kind = node:type()
		if kind == "fenced_code_block" or kind == "indented_code_block" then
			current.in_code = true
			return current
		end
		if kind == "list_item" or kind == "atx_heading" then
			for child in node:iter_children() do
				local child_kind = child:type()
				local child_row = child:start()
				if child_row == row then
					if child_kind:match("^atx_h%d_marker$") then
						current.heading = marker(child, bufnr)
					elseif child_kind == "task_list_marker_checked" or child_kind == "task_list_marker_unchecked" then
						current.task = marker(child, bufnr)
					end
				end
			end
		end
		node = node:parent()
	end

	node = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, col }, ignore_injections = false })
	while node do
		local kind = node:type()
		if kind == "code_span" then
			current.in_code = true
			return current
		elseif kind == "image" then
			return current
		elseif kind == "inline_link" then
			for child in node:iter_children() do
				if child:type() == "link_destination" then
					current.link = vim.treesitter.get_node_text(child, bufnr)
					return current
				end
			end
		elseif kind == "uri_autolink" then
			current.link = vim.treesitter.get_node_text(node, bufnr):gsub("^<", ""):gsub(">$", "")
			return current
		end
		node = node:parent()
	end

	current.link = bare_url(vim.api.nvim_get_current_line(), col)
	return current
end

return M
