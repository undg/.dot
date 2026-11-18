describe("opening clipboard paths", function()
	local original_getreg
	local original_notify
	local original_buffer
	local original_keymap
	local path
	local clipboard

	before_each(function()
		original_getreg = vim.fn.getreg
		original_notify = vim.notify
		original_buffer = vim.api.nvim_get_current_buf()
		original_keymap = Keymap
		Keymap = Keymap or { normal = function() end }
		require("custom.open-path")
		path = vim.fn.tempname() .. ".tsx"
		vim.fn.writefile(vim.fn["repeat"]({ string.rep("x", 60) }, 160), path)
		vim.fn.getreg = function(register)
			if register == "+" then
				return clipboard
			end
			return original_getreg(register)
		end
		vim.notify = function() end
	end)

	after_each(function()
		vim.fn.getreg = original_getreg
		vim.notify = original_notify
		Keymap = original_keymap
		local buffer = vim.fn.bufnr(path)
		if buffer ~= -1 then
			require("utils.marks").remove_buf(buffer)
			vim.api.nvim_buf_delete(buffer, { force = true })
		end
		if vim.api.nvim_buf_is_valid(original_buffer) then
			vim.api.nvim_set_current_buf(original_buffer)
		end
		vim.fn.delete(path)
	end)

	it("opens Vitest locations at the specified line and column", function()
		clipboard = path .. ":158:40"
		vim.cmd.Openpath()
		assert.are.equal(path, vim.api.nvim_buf_get_name(0))
		assert.are.same({ 158, 39 }, vim.api.nvim_win_get_cursor(0))
		assert.is_nil(vim.b.openpath_end_line)
	end)

	it("keeps opening line-only locations at the first column", function()
		clipboard = path .. ":158"
		vim.cmd.Openpath()
		assert.are.equal(path, vim.api.nvim_buf_get_name(0))
		assert.are.same({ 158, 0 }, vim.api.nvim_win_get_cursor(0))
	end)

	it("preserves supported line ranges", function()
		for _, suffix in ipairs({ ":150-158", ":L150-L158" }) do
			clipboard = path .. suffix
			vim.cmd.Openpath()
			assert.are.equal(path, vim.api.nvim_buf_get_name(0))
			assert.are.same({ 150, 0 }, vim.api.nvim_win_get_cursor(0))
			assert.are.equal(158, vim.b.openpath_end_line)
		end
	end)

	it("clamps columns outside the line", function()
		for _, location in ipairs({ { ":158:0", 0 }, { ":158:999", 59 } }) do
			clipboard = path .. location[1]
			vim.cmd.Openpath()
			assert.are.same({ 158, location[2] }, vim.api.nvim_win_get_cursor(0))
		end
	end)
end)
