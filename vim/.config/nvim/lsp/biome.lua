return {
	cmd = { "biome", "lsp-proxy" },
	filetypes = {
		"astro",
		"css",
		"graphql",
		"json",
		"jsonc",
		"svelte",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(fname, { "biome.json", "biome.jsonc" })
		if root then
			on_dir(root)
		end
	end,
}
