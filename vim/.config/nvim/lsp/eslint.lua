return {
	-- cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	on_attach = function(client, bufnr)
		-- Explanation: Setting `documentFormattingProvider` to false prevents the LSP client from handling document formatting, which is typically handled by ESLint itself.
		client.server_capabilities.documentFormattingProvider = true
		local function buf_set_option(name, value)
			vim.api.nvim_buf_set_option(bufnr, name, value)
		end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	end,
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		nodePath = "",
		onIgnoredFiles = "off",
		packageManager = "pnpm",
		quiet = false,
		rulesCustomizations = {
			{ rule = "@typescript-eslint/no-unused-vars", severity = "off" },
			{ rule = "spaced-comment",                    severity = "off" },
			{ rule = "simple-import-sort/imports",        severity = "off" },
			{ rule = "react/self-closing-comp",           severity = "off" },
		},
		run = "onType", -- onSave, onType
		severity_sort = true,
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
		experimental = {
			useFlatConfig = true,
		},
	},
	-- commands = {
	--     EslintFixAll = {
	--         function()
	--             vim.lsp.buf.format({ async = false })
	--             configs.eslint.fix_all({ sync = true, bufnr = 0 })
	--         end,
	--         description = 'Fix all eslint problems for this buffer'
	--     },
	--     EslintRunOnBuffer = {
	--         function()
	--             vim.lsp.buf.execute_command({
	--                 command = "_typescript.eslint.executeAutofix",
	--                 arguments = { vim.api.nvim_buf_get_name(0) }
	--             })
	--         end,
	--         description = 'Run ESLint on the current buffer',
	--     },
	-- },
}
