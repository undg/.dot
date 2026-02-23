require("config")

-- LSP servers to enable (config files in lsp/ directory)
-- These names match the vim.lsp.config naming convention
local lsp_servers = {
	"json-lsp",
	"yaml-language-server",
	"lua_ls",
	"eslint",
	"biome",
	"gopls",
	"basedpyright",
	"ruff",
	"cssls",
	"html",
	"marksman",
	"bashls",
	"tailwindcss",
	"cssmodules_ls",
	"svelte",
}

-- Mason package names (for auto-installation)
-- Maps vim.lsp.config names to Mason package names
-- Reference: https://mason-registry.dev/registry/list
local mason_packages = {
	["json-lsp"] = "json-lsp",
	["yaml-language-server"] = "yaml-language-server",
	["lua_ls"] = "lua-language-server",
	["eslint"] = "eslint-lsp",
	["biome"] = "biome",
	["gopls"] = "gopls",
	["basedpyright"] = "basedpyright",
	["ruff"] = "ruff",
	["cssls"] = "css-lsp",
	["html"] = "html-lsp",
	["marksman"] = "marksman",
	["bashls"] = "bash-language-server",
	["tailwindcss"] = "tailwindcss-language-server",
	["cssmodules_ls"] = "cssmodules-language-server",
	["svelte"] = "svelte-language-server",
}

local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
	vim.notify("lsp.lua: missing mason-tool-installer", vim.log.levels.ERROR)
else
	local ensure_installed = {
		-- Formatters/linters
		"stylua",
		"prettierd",
		"prettier",
		"shfmt",
		"goimports",
	}

	-- Add LSP packages
	for _, server in ipairs(lsp_servers) do
		table.insert(ensure_installed, mason_packages[server])
	end

	mason_tool_installer.setup({
		ensure_installed = ensure_installed,
		run_on_start = true,
	})
end

-- Enable LSP servers using native vim.lsp (Neovim 0.11+)
-- Configs are loaded from lsp/<name>.lua files
vim.lsp.enable(lsp_servers)
