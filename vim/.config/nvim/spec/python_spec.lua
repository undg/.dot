local python = require("utils.python")

local function executable(path)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	vim.fn.writefile({ "#!/bin/sh", "exit 0" }, path)
	assert(vim.fn.setfperm(path, "rwx------") == 1)
end

describe("Python project tools", function()
	local workspace
	local bufnr
	local get_client_by_id = vim.lsp.get_client_by_id

	local function configure_signs(id, tool, root)
		local client = { id = id, name = tool, root_dir = root, server_capabilities = {} }
		vim.lsp.get_client_by_id = function(client_id)
			return client_id == id and client or get_client_by_id(client_id)
		end
		python.diagnostic_signs(client)
	end

	before_each(function()
		workspace = vim.fn.tempname()
		vim.fn.mkdir(workspace, "p")
	end)

	after_each(function()
		vim.lsp.get_client_by_id = get_client_by_id
		if bufnr then
			vim.api.nvim_buf_delete(bufnr, { force = true })
			bufnr = nil
		end
		vim.fn.delete(workspace, "rf")
	end)

	it("uses a workspace Ruff for a nested uv project unless it has its own", function()
		local project = workspace .. "/server/scheduler"
		vim.fn.mkdir(project, "p")
		vim.fn.writefile({ "gitdir: /example" }, workspace .. "/.git")
		vim.fn.writefile({}, workspace .. "/.ruff.toml")
		vim.fn.writefile({}, project .. "/pyproject.toml")
		bufnr = vim.fn.bufadd(project .. "/job.py")
		local workspace_ruff = workspace .. "/.venv/bin/ruff"
		executable(workspace_ruff)

		local root = python.ruff_root(bufnr)
		assert.equals(project, root)
		assert.equals(workspace_ruff, python.venv_executable(root, "ruff"))

		local project_ruff = project .. "/.venv/bin/ruff"
		executable(project_ruff)
		assert.equals(project_ruff, python.venv_executable(root, "ruff"))
	end)

	it("does not borrow tools from outside a nested Git worktree", function()
		local project = workspace .. "/worktree"
		vim.fn.mkdir(project, "p")
		vim.fn.writefile({ "gitdir: /example" }, project .. "/.git")
		vim.fn.writefile({}, workspace .. "/pyproject.toml")
		executable(workspace .. "/.venv/bin/ruff")
		bufnr = vim.fn.bufadd(project .. "/main.py")

		local root = python.ruff_root(bufnr)
		assert.equals(project, root)
		assert.is_nil(python.venv_executable(root, "ruff"))
	end)

	it("roots a standalone file at its own directory", function()
		bufnr = vim.fn.bufadd(workspace .. "/standalone.py")
		assert.equals(workspace, python.ruff_root(bufnr))
	end)

	it("uses uppercase signs for workspace Ruff and lowercase for fallback Basedpyright", function()
		local project = workspace .. "/server/scheduler"
		vim.fn.mkdir(project, "p")
		vim.fn.writefile({ "gitdir: /example" }, workspace .. "/.git")
		vim.fn.writefile({}, workspace .. "/.ruff.toml")
		vim.fn.writefile({ "[tool.mypy]" }, project .. "/pyproject.toml")

		for id, tool in pairs({ [101] = "ruff", [102] = "basedpyright" }) do
			configure_signs(id, tool, project)
			for _, pull in ipairs({ false, true }) do
				local namespace = vim.lsp.diagnostic.get_namespace(id, pull)
				local text = vim.diagnostic.config(nil, namespace).signs.text
				assert.equals(tool == "ruff" and "E" or "e", text[vim.diagnostic.severity.ERROR])
				assert.equals(tool == "ruff" and "W" or "w", text[vim.diagnostic.severity.WARN])
			end
		end
	end)

	it("uses uppercase signs for Basedpyright configured in pyproject.toml", function()
		vim.fn.writefile({ "[tool.basedpyright]", 'typeCheckingMode = "strict"' }, workspace .. "/pyproject.toml")
		local id = 103
		configure_signs(id, "basedpyright", workspace)

		local namespace = vim.lsp.diagnostic.get_namespace(id)
		local text = vim.diagnostic.config(nil, namespace).signs.text
		assert.equals("E", text[vim.diagnostic.severity.ERROR])
		assert.equals("W", text[vim.diagnostic.severity.WARN])
	end)
end)
