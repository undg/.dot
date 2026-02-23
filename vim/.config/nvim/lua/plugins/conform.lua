local function format_on_save_toggle()
	vim.g.format_on_save = not vim.g.format_on_save

	local msg = "Format on save = OFF"
	if vim.g.format_on_save then
		msg = "Format on save = ON"
	end

	vim.notify(msg, vim.log.levels.INFO)
end

---Detect if project uses Biome (biome.json exists)
---@return boolean
local function has_biome_config()
	return vim.fs.root(0, "biome.json") ~= nil
end

---Detect if project uses Prettier (.prettierrc or prettier.config.* exists)
---@return boolean
local function has_prettier_config()
	local prettier_configs = {
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.mjs",
		".prettierrc.cjs",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.mjs",
		"prettier.config.cjs",
	}
	return vim.fs.root(0, prettier_configs) ~= nil
end

---Get appropriate JS/JSON formatter based on project config
---Biome is preferred if both configs exist (faster)
---@return string[]
local function js_formatter()
	if has_biome_config() then
		return { "biome" }
	elseif has_prettier_config() then
		return { "prettierd", "prettier" }
	else
		-- Default to biome for new projects
		return { "biome", "prettierd", "prettier" }
	end
end

return {
	"stevearc/conform.nvim", -- https://github.com/stevearc/conform.nvim
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				json = js_formatter,
				jsonc = js_formatter,
				python = { "ruff_organize_imports", "ruff_format" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				sh = { "shfmt" },
				go = { "goimports", "gofmt" },
				html = js_formatter,
				javascript = js_formatter,
				typescript = js_formatter,
				javascriptreact = js_formatter,
				typescriptreact = js_formatter,
				markdown = js_formatter,
				yaml = js_formatter,
			},
			formatters = {
				prettier = {
					prepend_args = { "--prose-wrap", "preserve" },
				},
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
			{ "<leader>p", require("conform").format, { desc = "Format" } },
		})
	end,
}
