local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local ts_snippets = require("snippets.typescript")

-- stylua: ignore
local ts_react_snippet = {
}

local merged_snippets = {}
local ts_snippet_map = {}

-- Index TypeScript snippets by trigger for easy lookup
for _, snippet in ipairs(ts_react_snippet) do
	ts_snippet_map[snippet.trigger] = true
	table.insert(merged_snippets, snippet)
end

-- Add JavaScript snippets that don't conflict with TypeScript ones
for _, snippet in ipairs(ts_snippets) do
	if not ts_snippet_map[snippet.trigger] then
		table.insert(merged_snippets, snippet)
	end
end

return merged_snippets
