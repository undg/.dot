-- This is fix for false positive vim.notify "No information available" that is not true.

-- Other issues with same problem:
-- https://www.reddit.com/r/neovim/comments/xw9d4h/i_keep_getting_no_information_available_messages/
-- https://github.com/neovim/nvim-lspconfig/issues/1931

local function fix_by_custom_hover()
	local border_ok, border = pcall(require, 'utils.border')
	local not_ok = not border_ok and 'utils.border' --
		or false

	if not_ok then
		vim.notify('plugins/mason.lua: missing required ', not_ok)
	end

	-- Replace hover function with custom implementation
	-- https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
	vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
		config = config or { border = border }
		config.focus_id = ctx.method
		if not (result and result.contents) then
			return
		end
		local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
		markdown_lines = vim.lsp.util.split(markdown_lines)
		if vim.tbl_isempty(markdown_lines) then
			return
		end
		return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
	end
end

local ok_notify, notify = pcall(require, 'notify')

-- See https://github.com/neovim/nvim-lspconfig/issues/1931#issuecomment-1297599534
local function fix_by_filter_notify()
	local banned_messages = { 'No information available' }
	vim.notify = function(msg, ...)
		for _, banned in ipairs(banned_messages) do
			if msg == banned then
				return
			end
		end
		return notify(msg, ...)
	end
end

if ok_notify then
	-- Chose one fix and uncomment
	fix_by_filter_notify()
end
-- fix_by_custom_hover()
