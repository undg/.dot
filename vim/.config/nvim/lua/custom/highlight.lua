local ok_highlight, highlight = pcall(require, "utils.highlight")

local not_ok = not ok_highlight and "undotree" --
	or false

if not_ok then
	vim.notify("custom/highlight.lua: requirement's missing - " .. not_ok, vim.log.levels.ERROR)
end

-- use only in visual
vim.api.nvim_create_user_command("HiglightLines", function(opts)
	highlight.toggle_lines(opts.line1, opts.line2)
	vim.api.nvim_input("<Esc>")
end, { range = true })

-- mappings
Keymap.normal("<Leader>1", ":HiglightLines<CR>", { silent = true })
Keymap.visual("<Leader>1", ":HiglightLines<CR>", { silent = true })

Keymap.normal("<Leader>2", highlight.clear_matches, { silent = true })
