-- highlight setup
vim.api.nvim_set_hl(0, "HiglightLInePresent", { bg = "#ffffff" })

-- mappings
Keymap.normal("<Leader>1", function()
	vim.fn.matchadd("HiglightLInePresent", "\\%" .. vim.fn.line(".") .. "l")
end, { silent = true })

Keymap.normal("<Leader>2", vim.fn.clearmatches, { silent = true })
