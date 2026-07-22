return {

	"FabijanZulj/blame.nvim", -- https://github.com/FabijanZulj/blame.nvim#configuration
	lazy = false,
	config = function()
		local utils = require("blame.utils")
		local previous_lines = {}

		local function get_previous_line(line_porcelain)
			if line_porcelain.hash:match("^0+$") or not line_porcelain.original_line then
				return nil
			end

			local buffer_name = vim.api.nvim_buf_get_name(0)
			local root = vim.fs.root(0, ".git")
			if buffer_name == "" or not root then
				return nil
			end

			local file_path = vim.fs.relpath(root, buffer_name)
			if not file_path then
				return nil
			end

			local cache_key = line_porcelain.hash .. ":" .. file_path
			if previous_lines[cache_key] == false then
				return nil
			end
			if previous_lines[cache_key] == nil then
				local result = vim.system({
					"git",
					"--no-pager",
					"show",
					line_porcelain.hash .. "^:" .. file_path,
				}, { cwd = root, text = true }):wait()

				if result.code ~= 0 then
					previous_lines[cache_key] = false
					return nil
				end

				previous_lines[cache_key] = vim.split(result.stdout, "\n", {
					plain = true,
					trimempty = false,
				})
			end

			return previous_lines[cache_key][line_porcelain.original_line]
		end

		local function format_blame_line(line_porcelain, config, idx)
			local hash = line_porcelain.hash:sub(1, 7)
			if hash == "0000000" then
				return {
					idx = idx,
					values = { { textValue = "Not commited", hl = "Comment" } },
					format = "%s",
				}
			end

			local date
			if config.relative_date_if_recent then
				date = utils.format_recent_date(config.date_format, line_porcelain.committer_time)
			else
				date = utils.format_time(config.date_format, line_porcelain.committer_time)
			end

			local values = {
				{ textValue = hash, hl = "Comment" },
				{ textValue = date, hl = hash },
				{ textValue = line_porcelain.author, hl = hash },
			}
			local previous_line = get_previous_line(line_porcelain)
			if previous_line then
				table.insert(values, { textValue = "← " .. previous_line, hl = "Comment" })
			end

			return {
				idx = idx,
				values = values,
				format = #values == 4 and "%s  %s  %s  %s" or "%s  %s  %s",
			}
		end

		require("blame").setup({
			format_fn = format_blame_line,
		})
		Keymap.normal("<leader>gb", ":BlameToggle<cr>", { desc = "Blame Toggle" })
	end,
}
