-- Basedpyright LSP configuration
-- Used alongside Ruff for fast linting and formatting
-- Basedpyright handles: type checking, hover, definitions
-- Ruff handles: fast linting (formatting/import organization done by conform.nvim)

-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
-- https://github.com/DetachHead/basedpyright/tree/main/docs/configuration

local python = require("utils.python")

return {
	cmd = python.lsp_cmd("basedpyright-langserver", "--stdio"),
	filetypes = { "python" },
	root_dir = function(bufnr, on_dir)
		on_dir(python.root(bufnr, { "pyrightconfig.json" }))
	end,
	on_init = python.diagnostic_signs,
	before_init = function(_, config)
		if not config.root_dir or not config.settings then
			return
		end

		local interpreter = python.venv_executable(config.root_dir, "python")
		if interpreter then
			config.settings.python = config.settings.python or {}
			config.settings.python.pythonPath = config.settings.python.pythonPath or interpreter
		end
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
