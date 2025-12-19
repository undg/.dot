local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local js_snippets = require("snippets.javascript")



local ts_snippet = {
	s("int", {
		t("interface "), i(1), t({ " {", "}" })
	}),
	s("newnspc", {
		t("namespace "), i(1), t({ " {", "}" })
	}),
	s("fun", {
		t("function "), i(1, "function_name"), t("("), i(2, "argument"), t(": "), i(3, "argument_type"), t({ ") {", "\t" }),
		i(0), t({ "", "}" })
	}),
	s("atom", {
		t("export const "),
		i(1, "name"),
		t("Atom = atom<"),
		i(2, "type"),
		t(">("),
		i(3, "defaultValue"),
		t({ ");", 'if (process.env.NODE_ENV !== "production") {', "\t" }),
		rep(1),
		t('Atom.debugLabel = "'),
		rep(1),
		t({ 'Atom";', "}" }),
		i(0),
	}),
	s("atomFromClip", {
		t("export const "),
		f(function()
			local clip = vim.fn.getreg('"')
			if clip ~= "" then
				return clip
			end
			return "name"
		end),
		t("Atom = atom<"),
		i(1, "type"),
		t(">("),
		i(2, "defaultValue"),
		t({ ");", 'if (process.env.NODE_ENV !== "production") {', "\t" }),
		f(function()
			local clip = vim.fn.getreg('"')
			if clip ~= "" then
				return clip
			end
			return "name"
		end),
		t('Atom.debugLabel = "'),
		f(function()
			local clip = vim.fn.getreg('"')
			if clip ~= "" then
				return clip
			end
			return "name"
		end),
		t({ 'Atom";', "}" }),
		i(0),
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
