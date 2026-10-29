local auto_reload = require("custom.auto-reload")

describe("background file reload", function()
	local files
	local buffers
	local original_autoread

	local function open_file(text)
		local path = vim.fn.tempname()
		table.insert(files, path)
		vim.fn.writefile({ text }, path)
		local buf = vim.fn.bufadd(path)
		vim.fn.bufload(buf)
		table.insert(buffers, buf)
		return buf, path
	end

	local function line(buf)
		return vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
	end

	before_each(function()
		files = {}
		buffers = {}
		original_autoread = vim.o.autoread
		vim.o.autoread = true
		auto_reload.setup()
	end)

	after_each(function()
		vim.api.nvim_exec_autocmds("VimLeavePre", { group = "AutoReload" })
		vim.cmd.only()
		for _, buf in ipairs(buffers) do
			vim.api.nvim_buf_delete(buf, { force = true })
		end
		for _, path in ipairs(files) do
			vim.fn.delete(path)
		end
		vim.o.autoread = original_autoread
	end)

	it("repeatedly reloads displayed files without focus or keyboard events", function()
		local buf, path = open_file("original")
		vim.api.nvim_set_current_buf(buf)

		vim.fn.writefile({ "first external change" }, path)
		assert(vim.wait(3000, function()
			return line(buf) == "first external change"
		end), "first external change was not reloaded")

		vim.fn.writefile({ "second external change, different size" }, path)
		assert(vim.wait(3000, function()
			return line(buf) == "second external change, different size"
		end), "timer did not keep checking while idle")
	end)

	it("preserves unsaved edits and leaves hidden or missing files alone", function()
		local visible, visible_path = open_file("original visible")
		vim.api.nvim_set_current_buf(visible)
		local hidden, hidden_path = open_file("original hidden")
		local dirty, dirty_path = open_file("original dirty")
		local missing, missing_path = open_file("original missing")
		local disabled, disabled_path = open_file("autoread disabled")
		vim.bo[disabled].autoread = false

		vim.cmd.vsplit()
		vim.api.nvim_set_current_buf(dirty)
		vim.api.nvim_buf_set_lines(dirty, 0, -1, false, { "unsaved edits" })
		vim.cmd.vsplit()
		vim.api.nvim_set_current_buf(missing)
		vim.fn.delete(missing_path)
		vim.cmd.vsplit()
		vim.api.nvim_set_current_buf(disabled)

		vim.fn.writefile({ "external disabled change" }, disabled_path)
		vim.fn.writefile({ "external visible change" }, visible_path)
		vim.fn.writefile({ "external hidden change" }, hidden_path)
		vim.fn.writefile({ "external dirty change" }, dirty_path)
		assert(vim.wait(3000, function()
			return line(visible) == "external visible change"
		end), "displayed clean file was not reloaded")

		assert(line(dirty) == "unsaved edits", "unsaved edits were overwritten")
		assert(vim.bo[dirty].modified, "unsaved edits lost their modified flag")
		assert(line(hidden) == "original hidden", "hidden buffer was reloaded")
		assert(line(missing) == "original missing", "deleted file lost its buffered contents")
		assert(line(disabled) == "autoread disabled", "buffer-local autoread setting was ignored")
	end)
end)
