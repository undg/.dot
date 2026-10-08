describe("Python Tree-sitter context", function()
	local test_buf

	before_each(function()
		test_buf = vim.api.nvim_create_buf(false, true)
		vim.bo[test_buf].filetype = "python"
	end)

	after_each(function()
		vim.api.nvim_buf_delete(test_buf, { force = true })
	end)

	local function definition_contexts(lines)
		vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, lines)
		local root = vim.treesitter.get_parser(test_buf, "python"):parse()[1]:root()
		local query = vim.treesitter.query.get("python", "context")
		local contexts = {}

		for _, match in query:iter_matches(root, test_buf, 0, -1) do
			local context
			local body
			for id, nodes in pairs(match) do
				local node = type(nodes) == "table" and nodes[#nodes] or nodes
				if query.captures[id] == "context" then
					context = node
				elseif query.captures[id] == "context.end" then
					body = node
				end
			end
			if
				context
				and (
					context:type() == "decorated_definition"
					or context:type() == "function_definition"
					or context:type() == "class_definition"
				)
			then
				local start_row = context:start()
				local body_row = body:start()
				table.insert(contexts, { context:type(), start_row, body_row })
			end
		end

		return contexts
	end

	it("shows decorators and the function signature without a duplicate header", function()
		assert.are.same(
			{ { "decorated_definition", 0, 5 } },
			definition_contexts({
				'@router.post("/editor/import-graph")',
				"@requires_auth",
				"async def editor_import_graph(",
				"    graph_id: str,",
				") -> dict:",
				"    pass",
			})
		)
	end)

	it("still shows undecorated function signatures", function()
		assert.are.same(
			{ { "function_definition", 0, 1 } },
			definition_contexts({
				"def plain_function():",
				"    pass",
			})
		)
	end)

	it("shows decorators on classes too", function()
		assert.are.same(
			{ { "decorated_definition", 0, 2 } },
			definition_contexts({
				"@register",
				"class Handler:",
				"    pass",
			})
		)
	end)
end)
