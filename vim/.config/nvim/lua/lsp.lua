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
vim.lsp.enable({
	"json-lsp",
	"yaml-language-server",
	"lua-language-server",
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
})

-- null_ls.setup({
-- 	sources = { null_ls.builtins.completion.tags, null_ls.builtins.hover.dictionary },
-- })
