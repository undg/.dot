local mcphub = require("mcphub")

-- Helper to get help content
local function get_help_content(topic)
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()

	local ok, err = pcall(function()
		vim.cmd("silent help " .. topic)
	end)

	if not ok then
		return nil, "Help topic not found: " .. topic
	end

	local help_buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(help_buf, 0, -1, false)

	-- Close help window if new one was created
	if vim.api.nvim_get_current_win() ~= current_win then
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
	end

	-- Delete help buffer if it's not the original
	if help_buf ~= current_buf and vim.api.nvim_buf_is_valid(help_buf) then
		pcall(vim.api.nvim_buf_delete, help_buf, { force = true })
	end

	vim.api.nvim_set_current_win(current_win)

	return table.concat(lines, "\n")
end

-- Tool: get_help
mcphub.add_tool("help", {
	name = "get_help",
	description = "Get Neovim help documentation for any topic, plugin, command, or function",
	inputSchema = {
		type = "object",
		properties = {
			topic = {
				type = "string",
				description = "Help topic (e.g., 'vim.lsp', 'telescope', ':help', 'lua-guide')",
			},
		},
		required = { "topic" },
	},
	handler = function(req, res)
		local content, err = get_help_content(req.params.topic)
		if not content then
			return res:error(err)
		end
		return res:text(content):send()
	end,
})

-- Tool: search_help
mcphub.add_tool("help", {
	name = "search_help",
	description = "Search available help topics/tags by pattern",
	inputSchema = {
		type = "object",
		properties = {
			pattern = {
				type = "string",
				description = "Search pattern (e.g., 'telescope', 'lsp', 'lua')",
			},
		},
		required = { "pattern" },
	},
	handler = function(req, res)
		local matches = vim.fn.getcompletion(req.params.pattern, "help")
		if #matches == 0 then
			return res:text("No help topics found matching: " .. req.params.pattern):send()
		end
		return res:text(table.concat(matches, "\n")):send()
	end,
})

-- Resource template: help://{topic}
mcphub.add_resource_template("help", {
	name = "help_topic",
	uriTemplate = "help://{topic}",
	description = "Access Neovim help documentation via URI",
	handler = function(req, res)
		local content, err = get_help_content(req.params.topic)
		if not content then
			return res:error(err)
		end
		return res:text(content, "text/plain"):send()
	end,
})
