local hu_ok, hu = pcall(require, "utils.hover-ui")
local not_ok = not hu_ok and "utils.hover-ui" --
	or false

if not_ok then
	vim.notify("plugins/mason.lua: missing required ", not_ok)
end

return {
	"williamboman/mason.nvim", -- https://github.com/williamboman/mason.nvim
	dependencies = {
		-- auto install predefined packages
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
	},
	config = function()
		require("mason").setup({
			ui = {
				border = hu.border,
			},
		})
	end,
}
