return {
	"nvim-lualine/lualine.nvim", -- https://github.com/nvim-lualine/lualine.nvim
	config = function()
		local sections_ok, s = pcall(require, "custom.lualine.sections")
		local opencode_ok = pcall(require, "opencode")


		local not_ok = not sections_ok and "custom.lualine.sections" --
			or not opencode_ok and "opencode"
			or false

		if not_ok then
			vim.notify("plugins/lualine.lua: ERROR require - " .. not_ok, vim.log.levels.ERROR)
		end


		local sections = {
			lualine_a = { s.progress, s.branch, s.harpoon },
			lualine_b = {},
			lualine_c = {},

			lualine_x = { "diagnostics", "diff", s.mcp, { require("opencode").statusline } },
			lualine_y = { s.cwd, s.fileformat, s.filetype },
			lualine_z = { s.location },
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				component_separators = { left = "", right = "" },

				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					-- statusline = { 'alpha' },
					-- winbar = { 'alpha' },
				},
				ignore_focus = {},
				always_divide_middle = false,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = sections,
			inactive_sections = sections,
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = { "nvim-tree", "fugitive", "mundo", "quickfix" },
		})
	end,
}
