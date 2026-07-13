local function start_treesitter(bufnr)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local filetype = vim.bo[bufnr].filetype
	if vim.bo[bufnr].buftype ~= "" or filetype == "" then
		return
	end

	pcall(vim.treesitter.start, bufnr)
end

return {
	"nvim-treesitter/nvim-treesitter", -- keep parser runtime available while migrating to Neovim 0.12 built-ins
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- `nvim-treesitter` 0.12 ships bundled queries under its `runtime/` dir.
		-- Keep that dir on `runtimepath` so `vim.treesitter.start()` can see the
		-- official queries across machines; without it TS/TSX can fall back to
		-- stale partial queries from `stdpath("data")/site/queries`.
		-- Upstream docs: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#setup
		local runtime_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
		if not vim.tbl_contains(vim.opt.runtimepath:get(), runtime_path) then
			vim.opt.runtimepath:prepend(runtime_path)
		end

		local group = vim.api.nvim_create_augroup("native_treesitter_base", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "*",
			callback = function(ev)
				start_treesitter(ev.buf)
			end,
		})

		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			start_treesitter(bufnr)
		end
	end,
}
