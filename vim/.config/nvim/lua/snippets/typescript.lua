local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local js_snippets = require("snippets.javascript")

-- stylua: ignore
local ts_snippet = {
	s("int", {
		t("interface "), i(1), t({ " {", "}" })
	}),
	s("nspc", {
		t("namespace "), i(1), t({ " {", "}" })
	}),
	s("fun", {
		t("function "), i(1, "function_name"), t("("), i(2, "argument"), t(": "), i(3, "argument_type"), t({ ") {", "\t" }),
		i(0), t({ "", "}" })
	}),
}

local merged_snippets = {}
local ts_snippet_map = {}

-- Index TypeScript snippets by trigger for easy lookup
for _, snippet in ipairs(ts_snippet) do
	ts_snippet_map[snippet.trigger] = true
	table.insert(merged_snippets, snippet)
end

-- Add JavaScript snippets that don't conflict with TypeScript ones
for _, snippet in ipairs(js_snippets) do
	if not ts_snippet_map[snippet.trigger] then
		table.insert(merged_snippets, snippet)
	end
end

return merged_snippets
