-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
---@class BasedpyrightSettings
---@field disableLanguageServices? boolean Disables all language services including hover, completion, etc.
---@field disableOrganizeImports? boolean Disables the "Organize Imports" command
---@field disableTaggedHints? boolean Disables grayed out/strikethrough diagnostics for unreachable/deprecated code
---@field openFilesOnly? boolean Deprecated, use analysis.diagnosticMode instead
---@field useLibraryCodeForTypes? boolean Deprecated, use analysis.useLibraryCodeForTypes instead
---@field analysis? BasedpyrightAnalysisSettings Analysis configuration

---@class BasedpyrightAnalysisSettings
---@field autoImportCompletions? boolean Enable auto-import completions (default: true)
---@field autoSearchPaths? boolean Auto-add common search paths like "src" (default: true)
---@field diagnosticMode? "openFilesOnly"|"workspace" Analysis scope (default: "openFilesOnly")
---@field logLevel? "Error"|"Warning"|"Information"|"Trace" Logging level (default: "Information")
---@field typeCheckingMode? "off"|"basic"|"standard"|"strict"|"recommended"|"all" Type checking strictness
---@field useLibraryCodeForTypes? boolean Parse library code for types when stubs missing (default: true)
---@field inlayHints? BasedpyrightInlayHintsSettings Inlay hints configuration
---@field useTypingExtensions? boolean Use typing_extensions for older Python versions (default: false)
---@field fileEnumerationTimeout? number Timeout for file enumeration in seconds (default: 10)
---@field autoFormatStrings? boolean Auto-insert 'f' in f-strings (default: true)
---@field baselineFile? string Path to baseline file for ignored diagnostics

---@class BasedpyrightInlayHintsSettings
---@field variableTypes? boolean Show variable type hints (default: true)
---@field callArgumentNames? boolean Show function argument name hints (default: true)
---@field callArgumentNamesMatching? boolean Show hints when variable name matches parameter (default: false)
---@field functionReturnTypes? boolean Show function return type hints (default: true)
---@field genericTypes? boolean Show inferred generic type hints (default: false)

---@class BasedpyrightConfig
---@field settings BasedpyrightSettingsWrapper

---@class BasedpyrightSettingsWrapper
---@field basedpyright BasedpyrightSettings

---@type BasedpyrightConfig
return {
	cmd = { 'basedpyright-langserver', '--stdio' },
	filetypes = { 'python' },
	-- Use current working directory as root (for projects with messy structure)
	-- This ensures basedpyright sees all Python files in the project
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fn.getcwd())
	end,
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "basic",
				inlayHints = {
					variableTypes = true,
					callArgumentNames = true,
					functionReturnTypes = true,
				},
			}
		},
	},
}
