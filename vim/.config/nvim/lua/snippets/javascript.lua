local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

-- stylua: ignore
return {
	s("fun", {
		t("function "), i(1, "function_name"), t("("), i(2, "argument"), t({ ") {", "\t" }),
		i(0), t({ "", "}" })
	}),
	s("cfun", {
		i(1, "const "), i(2, "name"), t(" = ("), i(3), t(") => "), i(0)
	}),
	s("des", {
		t("describe(`"), i(1, "description"), t("`, () => {"), t({ "", "\t" }), i(2), t({ "", "})" })
	}),
	s("it", {
		t("it(`"), i(1, "should"), t("`, () => {"), t({ "", "\t" }), i(2), t({ "", "})" })
	}),
	s("exp", {
		t("expect("), i(1), t(")"), i(2)
	}),
	s("cl", {
		t({ "console.log(", '  "%c ' }), rep(1), t({ ':",', '  "background: ' }), i(2, "Navy"), t("; color: "), i(3,
		" White"), t({ "; padding: 2px; border-radius:3px\",", "  " }), i(1), t({ ",", ")" })
	}),
	s("clc", {
		t({ 'console.log(', '  "\\x1b[41m  ' }), rep(1), t({ ':  \\x1b[0m",', '  ' }), i(1), t({ ",", ")" })
	}),
	s("fori", {
		t("for(let "), i(1, "i"), t(" = 0; "), rep(1), t("< "), i(2, "arr.length"), t("; "), rep(1), t("++) {"), t({ "",
		"\t" }), i(3), t({ "", "}" })
	}),
	s("forin", {
		t("for(let "), i(1, "key"), t(" = 0 in "), i(2, "list"), t(") {"), t({ "", "\t" }), i(2), t({ "", "}" })
	}),
	s("forof", {
		t("for(let "), i(1, "value"), t(" = 0 of "), i(2, "list"), t(") {"), t({ "", "\t" }), i(2), t({ "", "}" })
	}),
}
