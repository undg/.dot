local M = {}
local timer

local function check_visible_files()
	local mode = vim.api.nvim_get_mode()
	if mode.mode ~= "n" or mode.blocking or vim.fn.getcmdwintype() ~= "" or vim.fn.reg_executing() ~= "" then
		return
	end

	local checked = {}
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if not checked[buf] then
			checked[buf] = true
			local name = vim.api.nvim_buf_get_name(buf)
			local autoread = vim.bo[buf].autoread
			if autoread == nil then
				autoread = vim.go.autoread
			end
			-- Leave unsaved edits alone; normal conflict handling still applies when saving.
			if vim.bo[buf].buftype == "" and not vim.bo[buf].modified and autoread and name ~= "" then
				local stat = vim.uv.fs_stat(name)
				if stat and stat.type == "file" then
					-- The file can disappear between stat and checktime.
					pcall(vim.cmd.checktime, tostring(buf))
				end
			end
		end
	end
end

function M.setup()
	if timer then
		return
	end

	timer = assert(vim.uv.new_timer())
	timer:start(2000, 2000, vim.schedule_wrap(function()
		if timer then
			check_visible_files()
		end
	end))

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("AutoReload", { clear = true }),
		once = true,
		callback = function()
			timer:stop()
			timer:close()
			timer = nil
		end,
	})
end

return M
