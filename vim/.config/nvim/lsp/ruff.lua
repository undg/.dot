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

---@type table
return {
	cmd = { "ruff", "server", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	init_options = {
		settings = {
			-- Disable organize imports - handled by conform.nvim
			organizeImports = false,
			-- Disable fixAll - we'll handle this manually if needed
			fixAll = false,
			-- Ruff uses default lint rules (E, F) without explicit configuration
			-- Add lint configuration here if you want to customize rules
		},
	},
}
