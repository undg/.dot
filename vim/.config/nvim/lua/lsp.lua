local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local mason_installer_ok, mason_installer = pcall(require, "mason-tool-installer")
local null_ls_ok, null_ls = pcall(require, "null-ls")

local not_ok = not lspconfig_ok and "lspconfig not ok\n"
	or not cmp_nvim_lsp_ok and "cmp_nvim_lsp not ok\n"
	or not mason_ok and "mason not ok\n"
	or not mason_lspconfig_ok and "mason_lspconfig not ok\n"
	or not mason_installer_ok and "mason_installer not ok\n"
	or not null_ls_ok and "null_ls not ok\n"
	or false -- all good, not not_ok

if not_ok then
	vim.notify("lsp/init.lua: require failed - " .. not_ok, vim.log.levels.ERROR)
	return
end

-- Lsp server name is same as file name with config.
-- [key: type] = {
--      [key: lsp server name] = 'mason pkg name'
-- }
local lsp2mason = {
	cfg_file = {
		-- denols = "deno",
		jsonls = "json-lsp",
		-- tsserver = 'typescript-language-server',
		yamlls = "yaml-language-server",
		lua_ls = "lua-language-server",
		eslint = "eslint",
		gopls = "gopls",
		-- harper_ls = "harper-ls"
	},
	cfg_no_file = {
		cssls = "cssls",
		html = "html",
		ruff = "ruff",
		marksman = "marksman",
		bashls = "bash-language-server",
		tailwindcss = "tailwindcss-language-server",
		cssmodules_ls = "cssmodules-language-server",
		svelte = "svelte-language-server",
	},
}

null_ls.setup({
	sources = { null_ls.builtins.completion.tags, null_ls.builtins.hover.dictionary },
})

-- Non lsp Mason packages to auto install. Package name
local mason_non_lsp = {
	"actionlint", -- github action files diagnostic
}

-- Lsp server names that will be installed via Manson
local mason_lsp = {} -- mutate

mason.setup({})

local capabilities = cmp_nvim_lsp.default_capabilities()

for name in pairs(lsp2mason.cfg_file) do
	mason_lsp[#mason_lsp + 1] = name

	local config = require("lsp." .. name)

	config["capabilities"] = capabilities

	lspconfig[name].setup(config)
end

for name in pairs(lsp2mason.cfg_no_file) do
	mason_lsp[#mason_lsp + 1] = name

	local config = {}

	config["capabilities"] = capabilities

	lspconfig[name].setup(config)
end

mason_lspconfig.setup({
	ensure_installed = mason_lsp,
})

mason_installer.setup({
	ensure_installed = mason_non_lsp,
})
