local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- stylua: ignore
return {
	s("styleIgnore", {
		t('-- stylua: ignore')
	}),
}
