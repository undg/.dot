local markdown = require("custom.markdown")

-- These specs use real Markdown parsers and real buffer-local mappings.
describe("custom Markdown actions", function()
	local bufnr
	local existing_buffers
	local original_open
	local original_notify
	local opened_url
	local warnings
	local original_conceallevel
	local original_concealcursor
	local root = vim.fn.getcwd()

	local function set_lines(lines, row, col)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		vim.api.nvim_win_set_cursor(0, { row or 1, col or 0 })
	end

	local function press(keys)
		local encoded = vim.api.nvim_replace_termcodes(keys, true, false, true)
		vim.api.nvim_feedkeys(encoded, "xt", false)
	end

	before_each(function()
		existing_buffers = {}
		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			existing_buffers[buffer] = true
		end
		bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(bufnr)
		vim.api.nvim_buf_set_name(bufnr, root .. "/spec/markdown-source.md")
		vim.bo[bufnr].filetype = "markdown"
		vim.bo[bufnr].shiftwidth = 2
		vim.bo[bufnr].expandtab = true
		markdown.setup()

		opened_url = nil
		warnings = {}
		original_open = vim.ui.open
		original_notify = vim.notify
		original_conceallevel = vim.wo.conceallevel
		original_concealcursor = vim.wo.concealcursor
		vim.ui.open = function(url)
			opened_url = url
			return {}
		end
		vim.notify = function(message)
			table.insert(warnings, message)
		end
	end)

	after_each(function()
		vim.ui.open = original_open
		vim.notify = original_notify
		vim.wo.conceallevel = original_conceallevel
		vim.wo.concealcursor = original_concealcursor
		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if not existing_buffers[buffer] then
				vim.api.nvim_buf_delete(buffer, { force = true })
			end
		end
	end)

	it("toggles a task from its text, preserves the cursor, and supports undo", function()
		set_lines({ "- [ ] Finish the task" }, 1, 12)
		-- End the setup edit's undo block before exercising the mapping.
		vim.cmd("let &undolevels = &undolevels")
		press("<CR>")
		assert.are.equal("- [x] Finish the task", vim.api.nvim_get_current_line())
		assert.are.same({ 1, 12 }, vim.api.nvim_win_get_cursor(0))
		press("u")
		assert.are.equal("- [ ] Finish the task", vim.api.nvim_get_current_line())
	end)

	it("unchecks uppercase and nested ordered task markers", function()
		set_lines({ "- Parent", "  1. [X] Finished" }, 2, 12)
		press("<CR>")
		assert.are.equal("  1. [ ] Finished", vim.api.nvim_get_current_line())
		press("<CR>")
		assert.are.equal("  1. [x] Finished", vim.api.nvim_get_current_line())
	end)

	it("does not toggle a parent task from a continuation line", function()
		set_lines({ "- [ ] Parent task", "      continued text" }, 2, 10)
		press("<CR>")
		assert.are.same(
			{ "- [ ] Parent task", "      continued text" },
			vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		)
	end)

	it("follows the link under the cursor before toggling a task", function()
		set_lines({ "- [ ] Read [this](https://example.com)" }, 1, 13)
		press("<CR>")
		assert.are.equal("https://example.com", opened_url)
		assert.are.equal("- [ ] Read [this](https://example.com)", vim.api.nvim_get_current_line())
	end)

	it("selects the correct link when a line has several", function()
		set_lines({ "[first](https://one.example) [second](https://two.example)" }, 1, 31)
		press("<CR>")
		assert.are.equal("https://two.example", opened_url)
	end)

	it("opens angle-bracket URLs and bare URLs without sentence punctuation", function()
		set_lines({ "See <https://example.com/a>" }, 1, 12)
		press("<CR>")
		assert.are.equal("https://example.com/a", opened_url)
		set_lines({ "See (https://example.com/a_(b))." }, 1, 12)
		press("<CR>")
		assert.are.equal("https://example.com/a_(b)", opened_url)
	end)

	it("resolves local links from the Markdown file rather than the working directory", function()
		set_lines({ "[readme](../%52EADME.md)" }, 1, 3)
		vim.bo[bufnr].modified = false
		press("<CR>")
		assert.are.equal(root .. "/README.md", vim.api.nvim_buf_get_name(0))
		press("<C-o>")
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
	end)

	it("opens decoded spaces and filename metacharacters literally", function()
		set_lines({ "[note](./a%20b%25%23%7C.md)" }, 1, 3)
		vim.bo[bufnr].modified = false
		local path = root .. "/spec/a b%#|.md"
		local original_readable = vim.fn.filereadable
		vim.fn.filereadable = function(candidate)
			return candidate == path and 1 or original_readable(candidate)
		end
		local ok, err = pcall(press, "<CR>")
		vim.fn.filereadable = original_readable
		assert.is_true(ok, err)
		assert.are.equal(path, vim.api.nvim_buf_get_name(0))
	end)

	it("does not create missing targets or toggle the task containing their link", function()
		set_lines({ "- [ ] [missing](./no-such-markdown-target.md)" }, 1, 9)
		press("<CR>")
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
		assert.are.equal("- [ ] [missing](./no-such-markdown-target.md)", vim.api.nvim_get_current_line())
		assert.is_truthy(warnings[1]:find("does not exist", 1, true))
	end)

	it("does not execute URI schemes or accept local query strings", function()
		set_lines({ "[unsafe](javascript:alert)" }, 1, 3)
		press("<CR>")
		assert.is_nil(opened_url)
		assert.is_truthy(warnings[1]:find("Unsupported link scheme", 1, true))
		set_lines({ "[section](../README.md?raw=1#testing)" }, 1, 3)
		press("<CR>")
		assert.is_truthy(warnings[2]:find("queries", 1, true))
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
	end)

	it("passes external URL queries and fragments to the browser unchanged", function()
		set_lines({ "[site](https://example.com/guide?view=full#section)" }, 1, 3)
		press("<CR>")
		assert.are.equal("https://example.com/guide?view=full#section", opened_url)
		assert.are.same({}, warnings)
	end)

	it("reports browser launch failures", function()
		vim.ui.open = function()
			return nil, "browser unavailable"
		end
		set_lines({ "[site](https://example.com)" }, 1, 3)
		press("<CR>")
		assert.is_truthy(warnings[1]:find("browser unavailable", 1, true))
	end)

	it("leaves plain text, reference links, and wikilinks untouched", function()
		for _, line in ipairs({ "Ordinary text", "[reference][id]", "[[wiki-note]]" }) do
			set_lines({ line }, 1, 3)
			press("<CR>")
			assert.are.equal(line, vim.api.nvim_get_current_line())
		end
		assert.is_nil(opened_url)
		assert.are.same({}, warnings)
	end)

	it("does not act on fenced, indented, or inline code examples", function()
		set_lines({ "```markdown", "- [ ] [site](https://example.com)", "```" }, 2, 10)
		press("<CR>")
		assert.are.equal("- [ ] [site](https://example.com)", vim.api.nvim_get_current_line())
		set_lines({ "    - [ ] Example" }, 1, 12)
		press("<CR>")
		assert.are.equal("    - [ ] Example", vim.api.nvim_get_current_line())
		set_lines({ "- [ ] `https://example.com`" }, 1, 15)
		press("<CR>")
		assert.are.equal("- [ ] `https://example.com`", vim.api.nvim_get_current_line())
		assert.is_nil(opened_url)
	end)

	it("works with rendered Markdown conceal settings", function()
		vim.wo.conceallevel = 2
		vim.wo.concealcursor = "n"
		set_lines({ "- [ ] [site](https://example.com)" }, 1, 9)
		press("<CR>")
		assert.are.equal("https://example.com", opened_url)
	end)

	it("shifts headings while preserving indentation, closing markers, and cursor text", function()
		set_lines({ "  ## Title ##" }, 1, 7)
		press(">>")
		assert.are.equal("  ### Title ##", vim.api.nvim_get_current_line())
		assert.are.same({ 1, 8 }, vim.api.nvim_win_get_cursor(0))
		press("<<")
		assert.are.equal("  ## Title ##", vim.api.nvim_get_current_line())
		assert.are.same({ 1, 7 }, vim.api.nvim_win_get_cursor(0))
	end)

	it("shifts a heading even when its title contains inline code under the cursor", function()
		set_lines({ "# Use `code` here" }, 1, 8)
		press(">>")
		assert.are.equal("## Use `code` here", vim.api.nvim_get_current_line())
	end)

	it("honors heading counts and clamps levels to one through six", function()
		set_lines({ "# Title" })
		press("2>>")
		assert.are.equal("### Title", vim.api.nvim_get_current_line())
		press("9>>")
		assert.are.equal("###### Title", vim.api.nvim_get_current_line())
		press(">>")
		assert.are.equal("###### Title", vim.api.nvim_get_current_line())
		press("9<<")
		press("<<")
		assert.are.equal("# Title", vim.api.nvim_get_current_line())
	end)

	it("keeps the cursor within shortened heading markers", function()
		set_lines({ "###### Title" }, 1, 5)
		press("3<<")
		assert.are.equal("### Title", vim.api.nvim_get_current_line())
		assert.are.same({ 1, 2 }, vim.api.nvim_win_get_cursor(0))
	end)

	it("retains ordinary indentation and line counts outside headings", function()
		set_lines({ "- First", "- Second", "- Third" })
		press("2>>")
		assert.are.same({ "  - First", "  - Second", "- Third" }, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
		press("2<<")
		assert.are.same({ "- First", "- Second", "- Third" }, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
	end)

	it("indents code-block heading examples and Setext headings normally", function()
		set_lines({ "```markdown", "# Example", "```" }, 2)
		press(">>")
		assert.are.equal("  # Example", vim.api.nvim_get_current_line())
		set_lines({ "Title", "=====" })
		press(">>")
		assert.are.equal("  Title", vim.api.nvim_get_current_line())
	end)

	it("attaches to existing and new Markdown buffers without changing other filetypes", function()
		markdown.setup()
		markdown.setup()
		assert.are.equal(1, vim.fn.maparg("<CR>", "n", false, true).buffer)
		assert.are.equal(1, #vim.api.nvim_get_autocmds({ group = "custom_markdown" }))
		local other = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(other)
		vim.bo[other].filetype = "lua"
		for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(other, "n")) do
			assert.is_falsy((mapping.desc or ""):find("Markdown:", 1, true))
		end
		vim.bo[other].filetype = "markdown"
		for _, key in ipairs({ "<CR>", ">>", "<<" }) do
			local mapping = vim.fn.maparg(key, "n", false, true)
			assert.are.equal(1, mapping.buffer)
			assert.is_truthy(mapping.desc:find("Markdown:", 1, true))
		end
		for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(other, "i")) do
			assert.is_falsy((mapping.desc or ""):find("Markdown:", 1, true))
		end
	end)
end)
