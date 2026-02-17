-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
-- https://github.com/DetachHead/basedpyright/tree/main/docs/configuration

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	-- Use current working directory as root (for projects with messy structure)
	-- This ensures basedpyright sees all Python files in the project
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fn.getcwd())
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
