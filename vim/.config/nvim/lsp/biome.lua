return {
	cmd = function(dispatchers, config)
		local command = "biome"
		local dir = config.root_dir or vim.fn.getcwd()
		while dir do
			local candidate = vim.fs.joinpath(dir, "node_modules", ".bin", "biome")
			if vim.fn.executable(candidate) == 1 then
				command = candidate
				break
			end
			local parent = vim.fs.dirname(dir)
			dir = parent ~= dir and parent or nil
		end

		return vim.lsp.rpc.start({ command, "lsp-proxy" }, dispatchers, {
			cwd = config.cmd_cwd,
			env = config.cmd_env,
			detached = config.detached,
		})
	end,
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
