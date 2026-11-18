describe("opening clipboard paths", function()
	local original_getreg
	local original_notify
	local original_buffer
	local original_keymap
	local original_harpoon_mark
	local path
	local clipboard

	before_each(function()
		original_getreg = vim.fn.getreg
		original_notify = vim.notify
		original_buffer = vim.api.nvim_get_current_buf()
		original_keymap = Keymap
		original_harpoon_mark = package.loaded["harpoon.mark"]
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
		package.loaded["harpoon.mark"] = original_harpoon_mark
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

	it("adds the opened file to the top of Harpoon without losing other marks", function()
		local first = { filename = "first.tsx", row = 10, col = 2 }
		local second = { filename = "second.tsx", row = 20, col = 3 }
		local added
		local marked_files = { first, second }
		package.loaded["harpoon.mark"] = {
			add_file = function()
				added = { filename = vim.api.nvim_buf_get_name(0) }
				table.insert(marked_files, added)
			end,
			get_length = function() return #marked_files end,
			get_marked_file = function(index) return marked_files[index] end,
			get_current_index = function() return 3 end,
			set_mark_list = function(files) marked_files = files end,
		}

		clipboard = path .. ":158:40"
		vim.cmd.OpenpathHarpoon()

		assert.are.equal(path, added.filename)
		assert.are.same({ added, first, second }, marked_files)
		assert.are.equal(path, vim.api.nvim_buf_get_name(0))
		assert.are.same({ 158, 39 }, vim.api.nvim_win_get_cursor(0))
	end)

	it("does not add the current buffer to Harpoon when the clipboard path is invalid", function()
		local added = false
		package.loaded["harpoon.mark"] = {
			add_file = function() added = true end,
		}

		for _, input in ipairs({ "", path .. ".missing" }) do
			clipboard = input
			vim.cmd.OpenpathHarpoon()
		end

		assert.is_false(added)
		assert.are.equal(original_buffer, vim.api.nvim_get_current_buf())
	end)

	it("reports a missing Harpoon dependency without failing to open the file", function()
		package.loaded["harpoon.mark"] = nil
		local original_preload = package.preload["harpoon.mark"]
		package.preload["harpoon.mark"] = function() error("Harpoon unavailable") end
		local message, level
		vim.notify = function(text, severity) message, level = text, severity end
		clipboard = path

		local ok, err = pcall(vim.cmd.OpenpathHarpoon)
		package.preload["harpoon.mark"] = original_preload

		assert.is_true(ok, tostring(err))
		assert.are.equal(path, vim.api.nvim_buf_get_name(0))
		assert.are.equal("lua/custom/open-path.lua: missing requirements - harpoon.mark", message)
		assert.are.equal(vim.log.levels.ERROR, level)
	end)

	it("clamps columns outside the line", function()
		for _, location in ipairs({ { ":158:0", 0 }, { ":158:999", 59 } }) do
			clipboard = path .. location[1]
			vim.cmd.Openpath()
			assert.are.same({ 158, location[2] }, vim.api.nvim_win_get_cursor(0))
		end
	end)
end)
