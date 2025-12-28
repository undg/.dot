return {
	"hedyhli/markdown-toc.nvim", -- https://github.com/hedyhli/markdown-toc.nvim
	ft = "markdown",          -- Lazy load on markdown filetype
	cmd = { "Mtoc" },         -- Or, lazy load on "Mtoc" command
	opts = {
		toc_list = {
			padding_lines = 0,
		},
		-- Your configuration here (optional)
	},
}
