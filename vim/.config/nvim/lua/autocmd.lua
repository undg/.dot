-- Fix auto comment.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- vim.opt.formatoptions:remove("c") -- Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
		-- vim.opt.formatoptions:remove("r") -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
		vim.opt.formatoptions:remove("o") -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
		-- read more... :help fo-table
	end,
})

-- Set wrap and spell in gitcommit and markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto-prepend commit message with branch type and ticket number
-- Format: type/ticket/description (e.g. feat/505140/group-color)
-- Will add: feat(505140):
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit" },
	callback = function()
		local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
		local type, ticket = branch:match("^(%w+)/(%d+)")

		if type and ticket then
			local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
			if first_line == "" then
				vim.api.nvim_buf_set_lines(0, 0, 1, false, { string.format("%s(%s): ", type, ticket) })
			end
		end
	end,
})

-- Highligh on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Set markdown as the filetype for the Cody history
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown.cody_history", "markdown.cody_prompt" },
	callback = function()
		vim.bo.filetype = "markdown"
		-- vim.api.nvim_win_set_width(0, 100)
	end,
})

-- Automatic toggling between line number modes
-- [Normal/Visual] hybrid. Relative line numbers and absolute on line with cursor position.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained", "InsertLeave" }, {
	callback = function()
		local win_cfg = vim.api.nvim_win_get_config(0)

		local is_floating_diagnostic = vim.api.nvim_win_get_config(0).relative == "win"

		-- Simplify UI for certain filetypes
		if --
			vim.bo.filetype == "alpha"
			or vim.bo.filetype == "help"
			or vim.bo.filetype == "NvimTree"
			or is_floating_diagnostic
		then
			vim.opt_local.relativenumber = false
			return
		end
		vim.opt_local.relativenumber = true
	end,
})

-- [Insert] absolute line numbers
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
	callback = function()
		vim.opt_local.relativenumber = false
	end,
})

-- Format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	callback = function(e)
		if vim.g.format_on_save then
			local ok_conform, conform = pcall(require, "conform")
			if not ok_conform then
				vim.notify("Can't require('conform')", vim.log.levels.ERROR, { title = "autocomd.lua:", timeout = 500 })
			end
			vim.notify_once(e.file, vim.log.levels.INFO, { title = "Save and format file:", timeout = 500 })
			conform.format()
		end
	end,
})

local typescript_ok = pcall(require, "typescript-tools")
local not_ok = not typescript_ok and "typescript-tools" --
	or false

if not_ok then
	vim.notify("autocmd.lua: requirement's missing - " .. not_ok, vim.log.levels.ERROR)
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		Keymap.normal("gi", ":TSToolsGoToSourceDefinition<cr>", { desc = "lsp: implementation" })
		Keymap.normal("gfr", ":TSToolsFileReferences<cr>", { desc = "lsp: show file references" })
	end,
})

-- Detect Git conflicts and set up a keymap to resolve them
vim.api.nvim_create_autocmd("User", {
	pattern = "GitConflictDetected",
	callback = function()
		-- vim.notify('Conflict detected in ' .. vim.fn.expand('<afile>'))
		vim.keymap.set("n", "cww", function()
			engage.conflict_buster() ---@diagnostic disable-line: undefined-global
			create_buffer_local_mappings() ---@diagnostic disable-line: undefined-global
		end)
	end,
})

---@brief Preserve folds and cursor position during format-on-save
---@details Captures window view state (including folds) before save/format,
---        then restores it after save completes. Prevents formatter from
---        messing with manual folds.
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local view = vim.fn.winsaveview()
		vim.api.nvim_create_autocmd("BufWritePost", {
			once = true,
			callback = function()
				vim.fn.winrestview(view)
			end,
		})
	end,
})

-- Disable line numbers and conceal in Copilot buffers.
--
-- Types of copilot buffers:
-- - `copilot-chat` - Main chat buffer
-- - `copilot-overlay` - Overlay buffers (e.g. help, info, diff)
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		-- Set buffer-local options
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.conceallevel = 0
	end,
})
