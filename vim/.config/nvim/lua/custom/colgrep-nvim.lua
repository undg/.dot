local M = {}

local state = {
	current_index = 0,
	query = nil,
	results = {},
}

local search_id = 0

local function notify(message, level)
	vim.notify(message, level, { title = "Colgrep" })
end

local function normalize_result(result)
	if type(result) ~= "table" then
		return nil
	end

	local unit = result.unit
	if type(unit) ~= "table" or type(unit.file) ~= "string" then
		return nil
	end

	local line = math.max(tonumber(unit.line) or 1, 1)
	local end_line = math.max(tonumber(unit.end_line) or line, line)
	local name = unit.qualified_name or unit.name

	return {
		end_line = end_line,
		line = line,
		name = type(name) == "string" and name or "",
		path = unit.file,
		signature = type(unit.signature) == "string" and unit.signature or "",
	}
end

local function parse_results(output)
	local ok, decoded = pcall(vim.json.decode, output)
	if not ok or type(decoded) ~= "table" then
		return nil
	end

	local results = {}
	for _, result in ipairs(decoded) do
		local normalized = normalize_result(result)
		if normalized then
			table.insert(results, normalized)
		end
	end

	return results
end

local function relative_path(path)
	local relative = vim.fn.fnamemodify(path, ":.")
	return relative:gsub("^%./", "")
end

local function open_result(index)
	local result = state.results[index]
	if not result then
		return
	end

	state.current_index = index
	require("custom.open-path").open(result.path, result.line, result.end_line)
end

local function show_picker()
	if not state.query then
		notify("No cached results. Run :Colgrep <query> first.", vim.log.levels.INFO)
		return
	end

	if #state.results == 0 then
		notify("Last search returned no results.", vim.log.levels.INFO)
		return
	end

	local pickers_ok, pickers = pcall(require, "telescope.pickers")
	local finders_ok, finders = pcall(require, "telescope.finders")
	local actions_ok, actions = pcall(require, "telescope.actions")
	local action_state_ok, action_state = pcall(require, "telescope.actions.state")
	local config_ok, config = pcall(require, "telescope.config")

	if not (pickers_ok and finders_ok and actions_ok and action_state_ok and config_ok) then
		notify("Telescope is not available.", vim.log.levels.ERROR)
		return
	end

	pickers
		.new({}, {
			prompt_title = string.format("Colgrep (%d): %s", #state.results, state.query),
			finder = finders.new_table({
				results = state.results,
				entry_maker = function(result)
					local location = string.format("%s:%d-%d", relative_path(result.path), result.line, result.end_line)
					local label = result.name ~= "" and "  " .. result.name or ""

					return {
						colgrep_index = result.index,
						display = location .. label,
						filename = result.path,
						lnum = result.line,
						ordinal = table.concat({ location, result.name, result.signature }, " "),
						text = result.signature,
						value = result,
					}
				end,
			}),
			previewer = config.values.qflist_previewer({}),
			sorter = config.values.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selected = action_state.get_selected_entry()
					if not selected then
						return
					end

					actions.close(prompt_bufnr)
					open_result(selected.colgrep_index)
				end)

				return true
			end,
		})
		:find()
end

local function search(query)
	if vim.fn.executable("colgrep") ~= 1 then
		notify("colgrep executable not found in $PATH.", vim.log.levels.ERROR)
		return
	end

	search_id = search_id + 1
	local current_search_id = search_id
	local cwd = vim.fn.getcwd()

	vim.system({ "colgrep", "--json", "--color", "never", "--", query }, { cwd = cwd, text = true }, function(process)
		vim.schedule(function()
			if current_search_id ~= search_id then
				return
			end

			if process.code ~= 0 then
				local message = vim.trim(process.stderr or "")
				notify(message ~= "" and message or "colgrep search failed.", vim.log.levels.ERROR)
				return
			end

			local results = parse_results(process.stdout or "")
			if not results then
				notify("Could not parse colgrep JSON output.", vim.log.levels.ERROR)
				return
			end

			for index, result in ipairs(results) do
				result.index = index
			end

			state.current_index = 0
			state.query = query
			state.results = results
			show_picker()
		end)
	end)
end

local function move_result(direction)
	if #state.results == 0 then
		local message = state.query and "Last search returned no results."
			or "No cached results. Run :Colgrep <query> first."
		notify(message, vim.log.levels.INFO)
		return
	end

	local index
	if state.current_index == 0 then
		index = direction > 0 and 1 or #state.results
	else
		index = state.current_index + direction
	end

	if index < 1 or index > #state.results then
		notify(direction > 0 and "Already at the last result." or "Already at the first result.", vim.log.levels.INFO)
		return
	end

	open_result(index)
end

function M.setup()
	vim.api.nvim_create_user_command("Colgrep", function(args)
		local query = vim.trim(args.args)
		if query == "" then
			show_picker()
			return
		end

		search(query)
	end, {
		desc = "Search code with colgrep",
		force = true,
		nargs = "*",
	})

	vim.api.nvim_create_user_command("ColgrepNext", function()
		move_result(1)
	end, { desc = "Open next Colgrep result", force = true })

	vim.api.nvim_create_user_command("ColgrepPrev", function()
		move_result(-1)
	end, { desc = "Open previous Colgrep result", force = true })
end

return M
