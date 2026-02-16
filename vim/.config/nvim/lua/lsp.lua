-- local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- local mason_ok, mason = pcall(require, "mason")
-- local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
-- local mason_installer_ok, mason_installer = pcall(require, "mason-tool-installer")
-- local null_ls_ok, null_ls = pcall(require, "null-ls")
--
-- local not_ok = not cmp_nvim_lsp_ok and "cmp_nvim_lsp not ok\n"
-- 	or not mason_ok and "mason not ok\n"
-- 	or not mason_lspconfig_ok and "mason_lspconfig not ok\n"
-- 	or not mason_installer_ok and "mason_installer not ok\n"
-- 	or not null_ls_ok and "null_ls not ok\n"
-- 	or false -- all good, not not_ok
--
-- if not_ok then
-- 	vim.notify("lsp/init.lua: require failed - " .. not_ok, vim.log.levels.ERROR)
-- 	return
-- end

require("config")

local lsp_servers = {
	"json-lsp",
	"yaml-language-server",
	"lua_ls",
	"eslint",
	"gopls",
	"basedpyright",
	"cssls",
	"html",
	"marksman",
	"bashls",
	"tailwindcss",
	"cssmodules_ls",
	"svelte",
}

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	vim.notify("lsp.lua: missing mason-lspconfig", vim.log.levels.ERROR)
else
	local mason_lspconfig_aliases = {
		["json-lsp"] = "jsonls",
		["yaml-language-server"] = "yamlls",
	}

	local mason_lsp_servers = {}
	for _, server in ipairs(lsp_servers) do
		mason_lsp_servers[#mason_lsp_servers + 1] = mason_lspconfig_aliases[server] or server
	end

	mason_lspconfig.setup({
		automatic_enable = false,
		ensure_installed = mason_lsp_servers,
		automatic_installation = true,
	})
end

local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
	vim.notify("lsp.lua: missing mason-tool-installer", vim.log.levels.ERROR)
else
	mason_tool_installer.setup({
		ensure_installed = {
			"stylua", -- lua
			"prettierd", -- js/ts
			"prettier", -- js/ts
			"shfmt", -- bash
			"goimports", -- golang
		},
		run_on_start = true,
	})
end

vim.lsp.enable(lsp_servers)

-- null_ls.setup({
-- 	sources = { null_ls.builtins.completion.tags, null_ls.builtins.hover.dictionary },
-- })
