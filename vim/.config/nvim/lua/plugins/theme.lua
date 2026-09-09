local ok_highlight, highlight = pcall(require, "utils.highlight")

local not_ok = not ok_highlight and "undotree" --
	or false

if not_ok then
	vim.notify("custom/highlight.lua: requirement's missing - " .. not_ok, vim.log.levels.ERROR)
end

local diff_add_bg = "#233b4f"
local diff_rm_bg = "#431313"
local cursorline_bg = "#2f2f2f"
local highlight_bg = "#003300"
local error_bg = "#ee6666"

return {
	"ellisonleao/gruvbox.nvim", -- https://github.com/ellisonleao/gruvbox.nvim
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			terminal_colors = true, -- add neovim terminal colors
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "hard", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = true,
		})
		vim.cmd([[colorscheme gruvbox]])

		vim.api.nvim_set_hl(0, "Cursorline", { bg = cursorline_bg })

		-- git diff colors
		vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = diff_rm_bg })
		vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = diff_rm_bg })
		vim.api.nvim_set_hl(0, "DiffDelete", { bg = diff_rm_bg })
		vim.api.nvim_set_hl(0, "DiffAdd", { bg = diff_add_bg })
		vim.api.nvim_set_hl(0, "DiffChange", { bg = diff_add_bg })
		vim.api.nvim_set_hl(0, "DiffText", { bg = diff_add_bg })

		-- highlight colors
		vim.api.nvim_set_hl(0, highlight.highlight_group, { bg = highlight_bg })

		-- Set statusbar (lightline)
		vim.g.lightline = {
			colorscheme = "gruvbox",
			active = { left = { { "mode", "paste" }, { "gitbranch", "readonly", "filename", "modified" } } },
			component_function = { gitbranch = "fugitive#head" },
		}

		vim.api.nvim_set_hl(0, "DiagnosticError", { bg = error_bg })
		-- vim.cmd("hi DiagnosticError guifg=#ee6666")
		--
		-- Map (lukas-reineke/indent-blankline.nvim)
		vim.g.indent_blankline_char = "┊"
		vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
		vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
		vim.g.indent_blankline_char_highlight = "LineNr"
		vim.g.indent_blankline_show_trailing_blankline_indent = false

		-- -- Style and layout for diagnostic/hover floating windows
		local styled = {
			border = "rounded",
			style = "minimal",
			noautocmd = true,
			wrap_at = 40,
		}

		vim.diagnostic.config({
			float = {
				border = styled.border,
				header = "diagnostic:",
				source = true,
				prefix = "  ", -- padding left
				suffix = "  ", -- padding right
				format = function(diagnostic)
					if diagnostic.source == "eslint" then
						return string.format(
							"%s\n%s\n%s",
							diagnostic.message,
							-- shows the name of the rule
							diagnostic.user_data.lsp.code,
							-- shows url to rule documentation
							diagnostic.user_data.lsp.codeDescription and diagnostic.user_data.lsp.codeDescription.href
							or "No documentation URL"
						)
					end
					return string.format("%s [%s]", diagnostic.message, diagnostic.source)
				end,
			},
		})
	end,
}
