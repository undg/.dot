local telescope_ok = pcall(require, "telescope")
local lspsaga_ok = pcall(require, "lspsaga")

local not_ok = not lspsaga_ok and "lspsaga" or not telescope_ok and "telescope" or false -- all ok

if not_ok then
	vim.notify("keymap/lsp.lua: requirement's missing - " .. not_ok, vim.log.levels.ERROR)
	return
end

Keymap.normal("<LEADER>rn", vim.lsp.buf.rename, { desc = "lsp: rename", silent = false, noremap = true })

Keymap.normal(
	"<LEADER>rfn",
	":TSToolsRenameFile sync<CR>",
	{ desc = "lsp: rename_file", silent = false, noremap = true }
)
Keymap.normal(
	"<LEADER>ri",
	":TSToolsOrganizeImports<cr>",
	{ desc = "lsp: Organize import", silent = false, noremap = true }
)
Keymap.normal(
	"<LEADER>ru",
	":TSToolsRemoveUnused<cr>",
	{ desc = "lsp: Organize import", silent = false, noremap = true }
)
Keymap.normal("K", function()
	if vim.bo.filetype == "help" then
		vim.api.nvim_feedkeys("K", "ni", true)
	else
		vim.lsp.buf.hover()
	end
end, { desc = "lsp: hover / help: go to ref", silent = true, noremap = true })

local str = require("utils.str")
local function code_action_add_import()
	vim.lsp.buf.code_action({
		filter = function(action)
			return str.starts_with(action.title, "Add import from") -- js/ts
				or str.starts_with(action.title, "Add all missing imports") -- js/ts
				or str.starts_with(action.title, "Update import from") -- js/ts
				or str.starts_with(action.title, "Add import:") -- go
		end,
	})
end

Keymap.normal("<leader>K", vim.lsp.buf.signature_help, { desc = "lsp: signature_help", silent = true, noremap = true })
Keymap.normal("ga", code_action_add_import, { desc = "lsp: source code_action" })

Keymap.normal("gA", vim.lsp.buf.code_action, { desc = "lsp: code_action" })
Keymap.visual("gA", vim.lsp.buf.code_action, { desc = "lsp: code_action" })

Keymap.normal("<leader>Gd", ":Lspsaga peek_definition<CR>", { desc = "lsp: peek_definition" })
Keymap.normal("Gd", ":Lspsaga peek_definition<CR>", { desc = "lsp: peek_definition" })

Keymap.normal("<leader>GD", ":Lspsaga peek_type_definition<CR>", { desc = "lsp: peek_type_definition" })
Keymap.normal("GD", ":Lspsaga peek_type_definition<CR>", { desc = "lsp: peek_type_definition" })

Keymap.normal("<leader>gd", vim.lsp.buf.definition, { desc = "lsp: definition" })
Keymap.normal("gd", ":Telescope lsp_definitions<cr>", { desc = "lsp: definition (telescope)" })

Keymap.normal("<leader>gD", vim.lsp.buf.type_definition, { desc = "lsp: type_definition" })
Keymap.normal("gD", ":Telescope lsp_type_definitions<cr>", { desc = "lsp: type_definition (telescope)" })

Keymap.normal("<leader>gr", vim.lsp.buf.references, { desc = "lsp: references" })
Keymap.normal("gr", ":Telescope lsp_references<cr>", { desc = "lsp: references (telescope)" })

Keymap.normal("<leader>gi", vim.lsp.buf.implementation, { desc = "lsp: implementation" })
Keymap.normal("gi", ":Telescope lsp_implementations<cr>", { desc = "lsp: implementation (telescope)" })

Keymap.normal(
	"<leader>gj",
	":lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, })<cr>",
	{ silent = true, noremap = true, desc = "lsp: diagnostic_goto_next ERROR" }
)
Keymap.normal("gj", vim.diagnostic.goto_next, { silent = true, noremap = true, desc = "lsp: diagnostic_goto_next" })
Keymap.normal(
	"<leader>gk",
	":lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, })<cr>",
	{ silent = true, noremap = true, desc = "lsp: diagnostic_goto_prev ERROR" }
)
Keymap.normal("gk", vim.diagnostic.goto_prev, { silent = true, noremap = true, desc = "lsp: diagnostic_goto_prev" })
Keymap.normal("gh", vim.diagnostic.open_float, { silent = true, noremap = true, desc = "lsp: diagnostic_open_float" })
