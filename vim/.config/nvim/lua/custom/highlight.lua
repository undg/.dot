local highlight = require("utils.highlight")

-- highlight setup
vim.api.nvim_set_hl(0, "HiglightLinePresent", { bg = "#003300" })

-- use only in visual
vim.api.nvim_create_user_command("HiglightLines", function(opts)
	highlight.highlight_lines(opts.line1, opts.line2)
	vim.api.nvim_input("<Esc>")
end, { range = true })

-- mappings
Keymap.normal("<Leader>1", ":HiglightLines<CR>", { silent = true })
Keymap.visual("<Leader>1", ":HiglightLines<CR>", { silent = true })

Keymap.normal("<Leader>2", highlight.clear_matches, { silent = true })
