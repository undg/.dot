-- Basedpyright LSP configuration
-- Used alongside Ruff for fast linting and formatting
-- Basedpyright handles: type checking, hover, definitions
-- Ruff handles: fast linting (formatting/import organization done by conform.nvim)

-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
-- https://github.com/DetachHead/basedpyright/tree/main/docs/configuration

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, {
			"pyproject.toml", -- modern
			"setup.py", -- legacy setup tools
			"setup.cfg", -- legacy alternative
			".git",  -- repo root
		}) or vim.fn.getcwd())
	end,
	settings = {
		basedpyright = {
			-- Disable organize imports - handled by conform.nvim via ruff
			disableOrganizeImports = true,
			-- Disable tagged hints - ruff handles style linting
			disableTaggedHints = true,
			analysis = {
				-- Keep type checking enabled (this is basedpyright's strength)
				typeCheckingMode = "basic",
				inlayHints = {
					variableTypes = true,
					callArgumentNames = true,
					functionReturnTypes = true,
				},
			},
		},
	},
}
