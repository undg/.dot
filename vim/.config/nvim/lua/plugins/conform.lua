local function format_on_save_toggle()
	vim.g.format_on_save = not vim.g.format_on_save

	local msg = "Format on save = OFF"
	if vim.g.format_on_save then
		msg = "Format on save = ON"
	end

	vim.notify(msg, vim.log.levels.INFO)
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
			-- Set this to change the default values when calling conform.format()
			-- This will also affect the default values for format_on_save/format_after_save
			default_format_opts = {
				lsp_format = "last",
			},
			-- Set the log level. Use `:ConformInfo` to see the location of the log file.
			log_level = vim.log.levels.ERROR,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
			-- Conform will notify you when no formatters are available for the buffer
			notify_no_formatters = true,
		})

		local wk_ok, wk = pcall(require, "which-key")
		local not_ok = not wk_ok and "which-key" --
			or false
		if not_ok then
			vim.notify("plugins/obsidian.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		wk.add({
			{ "<leader>s", group = "Toggle", silent = false },
			{ "<leader>S", format_on_save_toggle, { desc = "Toggle format on save" } },
			{ "<leader>p", require("conform").format , { desc = "Format" } },
		})
	end,
}
