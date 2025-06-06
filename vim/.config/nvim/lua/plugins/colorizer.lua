return {
	"uga-rosa/ccc.nvim", -- https://github.com/uga-rosa/ccc.nvim
	config = function()
		-- Enable true color
		vim.opt.termguicolors = true

		local ccc_ok, ccc = pcall(require, "ccc")
		local colors_ok, colors = pcall(require, "custom.colors")
		local not_ok = not colors_ok and "customcolors" --
			or not ccc_ok and "ccc"
			or false

		if not_ok then
			vim.notify("plugins/colorizer.lua: missing required ", not_ok)
		end

		-- local mapping = ccc.mapping

		ccc.setup({
			-- Your preferred settings
			-- Example: enable highlighter
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
			pickers = {
				ccc.picker.css_name,
				ccc.picker.hex,
				ccc.picker.css_rgb,
				-- ccc.picker.css_hsl,
				-- ccc.picker.css_hwb,
				-- ccc.picker.css_lab,
				-- ccc.picker.css_lch,
				-- ccc.picker.css_oklab,
				-- ccc.picker.css_oklch,
			},
		})

		Keymap.normal("<leader>cc", "", { desc = "(ccc)" })
		Keymap.normal("<leader>ccc", ":CccPick<cr>", { desc = "(ccc) Color picker" })
		Keymap.normal("<leader>cct", ":CccHighlighterToggle<cr>", { desc = "(ccc) Toggle color highlighter" })
		Keymap.normal("<leader>ccn", colors.next, { desc = "(ccc) next" })
		Keymap.normal("<leader>ccp", colors.prev, { desc = "(ccc) prev" })

		Keymap.normal("<leader>cc0", colors.go_by(1), { desc = "(ccc) next" })
		Keymap.normal("<leader>cc1", colors.go_by(2), { desc = "(ccc) next" })
		Keymap.normal("<leader>cc2", colors.go_by(3), { desc = "(ccc) next" })
		Keymap.normal("<leader>cc3", colors.go_by(4), { desc = "(ccc) next" })
		Keymap.normal("<leader>cc4", colors.go_by(5), { desc = "(ccc) next" })
		Keymap.normal("<leader>cc5", colors.go_by(6), { desc = "(ccc) next" })
	end,
}
