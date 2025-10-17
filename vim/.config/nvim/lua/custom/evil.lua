local M = {}

function M.execAndPrint()
	local line = vim.api.nvim_get_current_line()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local output = vim.fn.system(line)
	local formatted = string.format("```bash\n# $> %s\n%s\n```\n\n", line, output:gsub("\n$", ""))

	vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(formatted, "\n"))
	vim.api.nvim_win_set_cursor(0, { current_line, 0 })
end

M.desc = "Eval current line and paste output"

function M.createCommand()
	vim.api.nvim_create_user_command("EvilCommand", M.execAndPrint, { desc = M.desc })
end

return M
