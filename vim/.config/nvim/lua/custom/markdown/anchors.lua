local M = {}

local entities = { amp = "&", lt = "<", gt = ">", quot = '"', apos = "'", nbsp = " " }
local delimiters = {
	emphasis_delimiter = true,
	code_span_delimiter = true,
	html_tag = true,
}

local function inline_text(node, source)
	local _, _, first = node:start()
	local _, _, last = node:end_()
	local raw = source:sub(first + 1, last)
	local kind = node:type()
	if delimiters[kind] then
		return ""
	elseif kind == "inline_link" or kind == "full_reference_link" or kind == "collapsed_reference_link" then
		for child in node:iter_children() do
			if child:type() == "link_text" then
				return inline_text(child, source)
			end
		end
	elseif kind == "image" then
		for child in node:iter_children() do
			if child:type() == "image_description" then
				return inline_text(child, source)
			end
		end
	elseif kind == "entity_reference" then
		return entities[raw:sub(2, -2)] or raw
	elseif kind == "numeric_character_reference" then
		local value = raw:match("^&#(%d+);$")
		local hex = raw:match("^&#[xX](%x+);$")
		local number = value and tonumber(value) or hex and tonumber(hex, 16)
		if number and number > 0 and number <= 0x10FFFF then
			return vim.fn.nr2char(number)
		end
	end

	local parts = {}
	local offset = first
	for child in node:iter_children() do
		local _, _, child_first = child:start()
		local _, _, child_last = child:end_()
		parts[#parts + 1] = source:sub(offset + 1, child_first)
		parts[#parts + 1] = inline_text(child, source)
		offset = child_last
	end
	parts[#parts + 1] = source:sub(offset + 1, last)
	return table.concat(parts)
end

local function slug(text)
	local parser = vim.treesitter.get_string_parser(text, "markdown_inline")
	local title = inline_text(parser:parse()[1]:root(), text)
	local parts = {}
	for _, char in ipairs(vim.fn.split(vim.fn.tolower(title), "\\zs")) do
		local class = vim.fn.charclass(char)
		if char:match("%s") then
			parts[#parts + 1] = "-"
		elseif char == "-" or char == "_" or (class >= 2 and class ~= 3) then
			-- Keep Unicode letters/numbers, but not punctuation or emoji.
			parts[#parts + 1] = char
		end
	end
	return table.concat(parts)
end

---Find an ATX or Setext heading by a decoded, GitHub-style anchor.
---@param bufnr integer
---@param fragment string
---@return integer? row One-based destination row.
---@return string? error
function M.find(bufnr, fragment)
	if fragment == "" then
		return 1
	end

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	local inline_ok = pcall(vim.treesitter.language.add, "markdown_inline")
	if not ok or not inline_ok then
		return nil, "Heading navigation requires the markdown and markdown_inline Tree-sitter parsers"
	end

	local query = vim.treesitter.query.parse("markdown", "[(atx_heading) (setext_heading)] @heading")
	local root = parser:parse()[1]:root()
	local used = {}
	for _, heading in query:iter_captures(root, bufnr) do
		local content = heading:field("heading_content")[1]
		if content then
			local text = vim.trim(vim.treesitter.get_node_text(content, bufnr))
			if heading:type() == "atx_heading" then
				text = text:gsub("%s+#+%s*$", "")
			end
			local base = slug(text)
			local anchor = base
			local suffix = 0
			while used[anchor] do
				suffix = suffix + 1
				anchor = base .. "-" .. suffix
			end
			used[anchor] = true
			if anchor == fragment then
				local row = heading:start()
				return row + 1
			end
		end
	end

	return nil, "Heading not found: #" .. fragment
end

return M
