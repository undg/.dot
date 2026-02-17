local ok_twoslash, twoslash = pcall(require, "twoslash-queries")
if not ok_twoslash then
	vim.notify("lua/lsp/tsserver.lua: twoslash-queries fail", vim.log.levels.ERROR)
	return
end

-- Check whether it's a deno project or not
local function is_deno_project()
	local deno_files = { "deno.json", "deno.jsonc", "deno.lock" }

	for _, filepath in ipairs(deno_files) do
		filepath = table.concat({ vim.fn.getcwd(), filepath }, "/")

		if vim.uv.fs_stat(filepath) ~= nil then
			return true
		end
	end

	return false
end

return {
	root_markers = { "deno.json" },
	-- autostart = false,
	enable = is_deno_project(),
	single_file_support = false,
	init_options = {
		lint = true,
	},
	on_attach = function(client, bufnr)
		twoslash.attach(client, bufnr)
	end,
}
