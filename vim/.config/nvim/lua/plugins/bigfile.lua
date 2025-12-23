-- This plugin automatically disables certain features if the opened file is big.
-- File size and features to disable are configurable.
-- :h bigfile.nvim-setup

return {
	"LunarVim/bigfile.nvim", -- https://github.com/LunarVim/bigfile.nvim
	config = function()
		require("bigfile").setup({
			filesize = 0.5, -- size of the file in MiB, the plugin round file sizes to the closest MiB
			-- pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
			pattern = function(bufnr, filesize_mib)
				-- you can't use `nvim_buf_line_count` because this runs on BufReadPre
				local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
				local file_length = #file_contents
				local filetype = vim.filetype.match({ buf = bufnr })
				if file_length > 10000 then
					return true
				end
			end,
			features = { -- features to disable
				"indent_blankline",
				"illuminate",
				"lsp",
				"treesitter",
				-- "syntax",
				"matchparen",
				"vimopts",
				"filetype",
			},
		})
	end,
}
