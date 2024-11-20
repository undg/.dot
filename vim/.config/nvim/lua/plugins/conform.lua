--- Formats buffers using the attached language server clients
--- or using `conform` as a fallback.
local function format()
	local buf_clients = vim.lsp.get_clients()

	-- Check LSP clients that support formatting
	for _, client in pairs(buf_clients) do
		if client.supports_method("textDocument/formatting") then
			vim.lsp.buf.format({ async = true })
			vim.notify_once('format with lsp.')
			return
		end
	end

	vim.notify_once('format with conform.')
	-- Fallback on conform
	require("conform").format()
end

return {
	"stevearc/conform.nvim", -- https://github.com/stevearc/conform.nvim
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettierd", "prettier", stop_after_first = true },
				python = { "isort", "black" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				sh = { "shfmt" },
				go = { "goimports", "gofmt" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				reacttypescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			},
		})

		Keymap.normal("<leader>p", format, { desc = "Format" })

		Keymap.normal("<LEADER>P", function()
			vim.g.format_on_save = not vim.g.format_on_save

			local msg = "Format on save = OFF"
			if vim.g.format_on_save then
				msg = "Format on save = ON"
			end

			vim.notify(msg, vim.log.levels.INFO)
		end, { desc = "Toggle format on save" })
	end,
}
