local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function git_user()
	local handle = io.popen("git config user.name")
	if handle then
		local result = handle:read("*a")
		handle:close()
		return (result or ""):gsub("%s+$", "")
	end
	return ""
end

return {
	s("todo", {
		f(function()
			return vim.fn["GetCommentMarker"]() .. " @TODO (" .. git_user() .. ") " .. os.date("%Y-%m-%d") .. ": "
		end),
		i(1),
	}),
	s("todo//", {
		t("// @TODO (" .. git_user() .. ") " .. os.date("%Y-%m-%d") .. ": "),
		i(1),
	}),
	s("todo#", {
		t("# @TODO (" .. git_user() .. ") " .. os.date("%Y-%m-%d") .. ": "),
		i(1),
	}),
	s("todo--", {
		t("-- @TODO (" .. git_user() .. ") " .. os.date("%Y-%m-%d") .. ": "),
		i(1),
	}),
}
