-- highlight setup
-- use only in visual
vim.api.nvim_create_user_command('HiglightLines', function(opts)
	local lstart = opts.line1
	local lend = opts.line2

	for line = lstart, lend do
		vim.fn.matchaddpos("HighlightCurrent", { line })
	end

	vim.api.nvim_input("<Esc>")
end, { range = true }
)


-- mappings
Keymap.normal("<Leader>1", ":HiglightLines<CR>", { silent = true })
Keymap.visual("<Leader>1", ":HiglightLines<CR>", { silent = true })

Keymap.normal("<Leader>2", vim.fn.clearmatches, { silent = true })
