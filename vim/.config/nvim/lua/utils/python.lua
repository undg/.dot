local M = {}

local ruff_configs = { ".ruff.toml", "ruff.toml" }
local diagnostic_configs = {
	ruff = { files = ruff_configs, sections = { ruff = true } },
	basedpyright = { files = { "pyrightconfig.json" }, sections = { basedpyright = true, pyright = true } },
}

---Find the closest Python project without crossing a Git worktree boundary.
---@param bufnr integer
---@param tool_markers string[]
---@return string
function M.root(bufnr, tool_markers)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" then
		return vim.fn.getcwd()
	end

	local markers = vim.list_extend({ "pyproject.toml", "setup.py", "setup.cfg", ".git" }, tool_markers)
	return vim.fs.root(filename, { markers }) or vim.fs.dirname(filename) or vim.fn.getcwd()
end

---@param bufnr integer
---@return string
function M.ruff_root(bufnr)
	return M.root(bufnr, ruff_configs)
end

local function has_project_config(root, config)
	local boundary = vim.fs.root(root, ".git") or root
	local parent = vim.fs.dirname(boundary)
	local files = vim.fs.find(function(name, dir)
		if vim.tbl_contains(config.files, name) then
			return true
		end
		if name ~= "pyproject.toml" then
			return false
		end

		local ok, lines = pcall(vim.fn.readfile, vim.fs.joinpath(dir, name))
		if ok then
			for _, line in ipairs(lines) do
				local tool = line:match("^%s*%[%s*tool%s*%.%s*([%w_-]+)%s*[%.%]]")
				if tool and config.sections[tool] then
					return true
				end
			end
		end
		return false
	end, { path = root, upward = true, type = "file", stop = parent ~= boundary and parent or nil })
	return #files > 0
end

---Change only the gutter letters; keep diagnostic severity and colors.
---@param client vim.lsp.Client
function M.diagnostic_signs(client)
	local config = diagnostic_configs[client.name]
	if not config or not client.root_dir then
		return
	end

	local project = has_project_config(client.root_dir, config)
	local severity = vim.diagnostic.severity
	local opts = {
		signs = {
			text = {
				[severity.ERROR] = project and "E" or "e",
				[severity.WARN] = project and "W" or "w",
			},
		},
	}
	local get_namespace = vim.lsp.diagnostic.get_namespace
	local pull_id = vim.tbl_get(client.server_capabilities, "diagnosticProvider", "identifier")
	vim.diagnostic.config(opts, get_namespace(client.id, false))
	vim.diagnostic.config(opts, get_namespace(client.id, true, pull_id))
end

---Look for a tool in the project venv or an enclosing workspace's venv.
---@param root string
---@param name string
---@return string?
function M.venv_executable(root, name)
	local boundary = vim.fs.root(root, ".git") or root
	local dir = root
	while dir do
		local candidate = vim.fs.joinpath(dir, ".venv", "bin", name)
		if vim.fn.executable(candidate) == 1 then
			return candidate
		end
		if dir == boundary then
			break
		end
		local parent = vim.fs.dirname(dir)
		dir = parent ~= dir and parent or nil
	end
end

---Prefer a project-local server, leaving Mason/PATH as the fallback.
---@param name string
---@param arg string
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers, config: vim.lsp.ClientConfig): vim.lsp.rpc.PublicClient
function M.lsp_cmd(name, arg)
	return function(dispatchers, config)
		local root = config.root_dir or vim.fn.getcwd()
		local command = M.venv_executable(root, name) or name
		return vim.lsp.rpc.start({ command, arg }, dispatchers, {
			cwd = config.cmd_cwd or root,
			env = config.cmd_env,
			detached = config.detached,
		})
	end
end

return M
