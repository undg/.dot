-- Ruff LSP configuration
-- Used alongside basedpyright for fast linting
-- Basedpyright handles: type checking, hover, definitions
-- Ruff handles: fast linting (formatting/import organization done by conform.nvim)

---@class RuffSettings
---@field organizeImports? boolean Enable organize imports code action
---@field fixAll? boolean Enable fix all code action
---@field lint? RuffLintSettings Lint-specific settings
---@field format? RuffFormatSettings Format-specific settings

---@class RuffLintSettings
---@field select? string[] List of rule codes to enable
---@field ignore? string[] List of rule codes to ignore
---@field args? string[] Additional CLI arguments for ruff check

---@class RuffFormatSettings
---@field args? string[] Additional CLI arguments for ruff format

local python = require("utils.python")

return {
	cmd = python.lsp_cmd("ruff", "server"),
	filetypes = { "python" },
	root_dir = function(bufnr, on_dir)
		on_dir(python.ruff_root(bufnr))
	end,
	on_init = python.diagnostic_signs,
	init_options = {
		settings = {
			-- Disable organize imports - handled by conform.nvim
			organizeImports = false,
			-- Disable fixAll - we'll handle this manually if needed
			fixAll = false,
		},
	},
}
