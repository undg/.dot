-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
-- https://github.com/DetachHead/basedpyright/tree/main/docs/configuration

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, {
			"pyproject.toml", -- modern
			"setup.py", -- legacy setuptools
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
