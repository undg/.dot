return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { ".git", "package.json" },
	settings = {
		css = {
			validate = true,
		},
		scss = {
			validate = true,
		},
		less = {
			validate = true,
		},
	},
}
