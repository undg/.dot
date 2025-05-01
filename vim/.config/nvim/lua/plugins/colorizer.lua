return {
	'uga-rosa/ccc.nvim', -- https://github.com/uga-rosa/ccc.nvim
	config = function()
		-- Enable true color
		vim.opt.termguicolors = true

		local ccc = require("ccc")
		local mapping = ccc.mapping

		ccc.setup({
			-- Your preferred settings
			-- Example: enable highlighter
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
		})
	end
}
