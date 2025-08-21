local function lsp_actions_checker(args)
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_range_params(winnr, "utf-8")

	params.context = {
		triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
	}

	vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(error, results, context, config)
		-- results is an array of lsp.CodeAction
		P(results)
	end)
end

vim.api.nvim_create_user_command("LspActionsChecker", lsp_actions_checker, { desc = "Check available lsp actions" })
