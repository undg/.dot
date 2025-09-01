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
	--  @TODO (undg) 2025-09-01: create this snippet
	-- s("require_check", {
	-- 	t({ "local ok_" }), i(1, "NAME"), t(", "), rep(1), t(" = pcall(require, \""), i(2, "PKG_NAME"), t({ "\")", "" }),
	-- 	t({ "local not_ok = not ok_" }), rep(1), t(" and \""), rep(2), t({ "\" --", "" }),
	-- 	t({ "\t\tor false", "", "" }),
	-- 	t({ "if not_ok then", "" }),
	-- 	t({ "\tvim.notify(\"" }), f(function() return vim.fn.expand("%:t") end), t(
	-- ": requirement's missing - \" .. not_ok, vim.log.levels.ERROR)"), t({ "", "" }),
	-- 	t({ "end" })
	-- }),
}
