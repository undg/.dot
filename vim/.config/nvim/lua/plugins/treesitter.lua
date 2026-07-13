local function start_treesitter(bufnr)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local filetype = vim.bo[bufnr].filetype
	if vim.bo[bufnr].buftype ~= "" or filetype == "" then
		return
	end

	if filetype == "markdown" then
		return
	end

	pcall(vim.treesitter.start, bufnr)
end

return {
	"nvim-treesitter/nvim-treesitter", -- keep parser runtime available while migrating to Neovim 0.12 built-ins
	lazy = false,
	config = function()
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
