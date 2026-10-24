local markdown = require("custom.markdown")

describe("Markdown heading navigation", function()
	local bufnr
	local existing_buffers
	local original_bufnr
	local original_cursor
	local original_hidden
	local original_notify
	local warnings
	local root = vim.fn.getcwd()
	local target = root .. "/spec/markdown-anchor-target.md"

	local function set_lines(lines)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		vim.api.nvim_win_set_cursor(0, { 1, 3 })
	end

	local function press(keys)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "xt", false)
	end

	before_each(function()
		original_bufnr = vim.api.nvim_get_current_buf()
		original_cursor = vim.api.nvim_win_get_cursor(0)
		original_hidden = vim.o.hidden
		original_notify = vim.notify
		existing_buffers = {}
		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			existing_buffers[buffer] = true
		end
		bufnr = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_set_current_buf(bufnr)
		vim.bo[bufnr].filetype = "markdown"
		vim.o.hidden = true
		markdown.setup()
		warnings = {}
		vim.notify = function(message)
			warnings[#warnings + 1] = message
		end
	end)

	after_each(function()
		vim.notify = original_notify
		vim.o.hidden = true
		if vim.api.nvim_buf_is_valid(original_bufnr) then
			vim.api.nvim_set_current_buf(original_bufnr)
			vim.api.nvim_win_set_cursor(0, original_cursor)
		end
		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if not existing_buffers[buffer] then
				vim.api.nvim_buf_delete(buffer, { force = true })
			end
		end
		vim.o.hidden = original_hidden
	end)

	it("opens a relative file at its heading and can jump back without losing source edits", function()
		vim.api.nvim_buf_set_name(bufnr, root .. "/spec/markdown-anchor-source.md")
		set_lines({ "[jump](./markdown-anchor-target.md#optional-dependency-isolation)" })
		press("<CR>")
		assert.are.equal(target, vim.api.nvim_buf_get_name(0))
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.equal("## Optional dependency isolation", vim.api.nvim_get_current_line())
		assert.are.equal(
			"This text verifies that navigation reads a real file.",
			vim.api.nvim_buf_get_lines(0, 4, 5, false)[1]
		)
		assert.is_true(vim.bo[bufnr].modified)
		press("<C-o>")
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
		assert.are.same({ 1, 3 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("jumps within an unnamed modified buffer and records the source position", function()
		set_lines({ "[jump](#local-heading)", "", "## Local heading" })
		press("<CR>")
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.is_true(vim.bo[bufnr].modified)
		press("<C-o>")
		assert.are.same({ 1, 3 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("matches visible heading text rather than formatting or link destinations", function()
		set_lines({
			"[jump](#use-code-and-visible-label)",
			"",
			"## Use `code` and [**visible** label](https://example.com/ignored) ###",
		})
		press("<CR>")
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("removes punctuation but preserves literal underscores in heading text", function()
		set_lines({ "[jump](#api_name-déjà-vu)", "", "## API_name: Déjà vu!" })
		press("<CR>")
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("uses visible text for HTML tags and common character entities", function()
		set_lines({ "[jump](#fish--chips--code)", "", "## <em>Fish</em> &amp; Chips &#38; Code" })
		press("<CR>")
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("decodes percent-encoded fragments and preserves Unicode letters", function()
		set_lines({ "[jump](#caf%C3%A9-%E4%B8%96%E7%95%8C)", "", "## Café 世界" })
		press("<CR>")
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("assigns suffixes to duplicate headings in document order", function()
		set_lines({ "[jump](#repeat-1)", "", "# Repeat", "", "## Repeat" })
		press("<CR>")
		assert.are.same({ 5, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("avoids collisions between duplicate suffixes and literal heading names", function()
		set_lines({ "[jump](#repeat-1-1)", "", "# Repeat", "", "# Repeat", "", "# Repeat-1" })
		press("<CR>")
		assert.are.same({ 7, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("counts all earlier headings when assigning a later duplicate's suffix", function()
		set_lines({ "[jump](#repeat-2)", "", "# Repeat", "", "# Repeat-1", "", "# Repeat" })
		press("<CR>")
		assert.are.same({ 7, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("recognizes Setext headings", function()
		set_lines({ "[jump](#setext-title)", "", "Setext *title*", "-------------" })
		press("<CR>")
		assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("does not count heading examples in fenced or indented code", function()
		set_lines({
			"[jump](#target)",
			"",
			"```markdown",
			"# Target",
			"```",
			"",
			"    # Target",
			"",
			"## Target",
		})
		press("<CR>")
		assert.are.same({ 9, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)

	it("leaves the destination file open and reports a missing heading", function()
		vim.api.nvim_buf_set_name(bufnr, root .. "/spec/markdown-anchor-source.md")
		set_lines({ "[jump](./markdown-anchor-target.md#missing-heading)" })
		press("<CR>")
		assert.are.equal(target, vim.api.nvim_buf_get_name(0))
		assert.are.same({ 1, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.is_truthy(warnings[1]:find("Heading not found: #missing-heading", 1, true))
	end)

	it("does not move or change text when a same-file heading is missing", function()
		local lines = { "[jump](#missing-heading)", "", "## Existing heading" }
		set_lines(lines)
		press("<CR>")
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
		assert.are.same({ 1, 3 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same(lines, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
		assert.is_truthy(warnings[1]:find("Heading not found", 1, true))
	end)

	it("does not bypass Neovim's protection of unsaved source edits", function()
		vim.o.hidden = false
		vim.api.nvim_buf_set_name(bufnr, root .. "/spec/markdown-anchor-source.md")
		local lines = { "[jump](./markdown-anchor-target.md#optional-dependency-isolation)" }
		set_lines(lines)
		press("<CR>")
		assert.are.equal(bufnr, vim.api.nvim_get_current_buf())
		assert.are.same({ 1, 3 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same(lines, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
		assert.is_true(vim.bo[bufnr].modified)
		assert.is_truthy(warnings[1]:find("Could not open link", 1, true))
	end)

	it("treats an empty fragment as the top of the document", function()
		set_lines({ "# Title", "", "[top](#)" })
		vim.api.nvim_win_set_cursor(0, { 3, 2 })
		press("<CR>")
		assert.are.same({ 1, 0 }, vim.api.nvim_win_get_cursor(0))
		assert.are.same({}, warnings)
	end)
end)
