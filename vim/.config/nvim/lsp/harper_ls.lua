return {
	cmd = { "harper-ls", "--stdio" },
	filetypes = { "markdown", "text", "tex" },
	settings = {
		linters = {
			SentenceCapitalization = false,
			SpellCheck = false,
		},
	},
}
