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
				"lsp",
				"treesitter",
				"illuminate",
				"indent_blankline",
				-- "syntax",
				-- "filetype",
				-- "vimopts", -- removed: this disables undo with undolevels=-1
				"matchparen",
				-- Custom features:
				{
					name = "vimopts_with_undo",
					opts = { defer = false },
					disable = function()
						vim.opt_local.swapfile = false
						vim.opt_local.foldmethod = "manual"
						-- vim.opt_local.undolevels = -1  -- DON'T disable undo!
						-- vim.opt_local.undoreload = 0   -- DON'T disable undo reload!
						vim.opt_local.list = false
					end,
				},
				{
					name = "ufo",
					opts = { defer = false },
					disable = function()
						pcall(require("ufo").detach)
						vim.opt_local.foldenable = false
						vim.opt_local.foldcolumn = "0"
					end,
				},
				{
					name = "navic",
					opts = { defer = false },
					disable = function()
						vim.o.winbar = ""
					end,
				},
				{
					name = "ccc",
					opts = { defer = false },
					disable = function()
						pcall(vim.cmd, "CccHighlighterDisable")
					end,
				},
				-- {
				-- 	name = "gitsigns",
				-- 	opts = { defer = false },
				-- 	disable = function()
				-- 		vim.schedule(function()
				-- 			pcall(require("gitsigns.actions").detach)
				-- 		end)
				-- 	end,
				-- },
				{
					name = "extra_vimopts",
					opts = { defer = false },
					disable = function()
						vim.opt_local.cursorline = false
						vim.opt_local.spell = false
						-- vim.opt_local.list = false
						vim.opt_local.signcolumn = "yes:1"
					end,
				},
			},
		})
	end,
}
