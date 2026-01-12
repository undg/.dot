return {
	{
		"mfussenegger/nvim-dap",
		-- depencendies = {
		-- 	'mxsdev/nvim-dap-vscode-js',
		-- },
		config = function()
			local dap = require("dap")

			local function get_workspace_root()
				local package_json = vim.fs.find({ "package.json" }, { upward = true, type = "file" })[1]
				if package_json then
					return vim.fs.dirname(package_json)
				end

				local git_dir = vim.fs.find({ ".git" }, { upward = true, type = "directory" })[1]
				if git_dir then
					return vim.fs.dirname(git_dir)
				end

				return vim.loop.cwd()
			end

			local function setup_js_debug_adapters()
				local function configure_from_path(js_debug_path)
					dap.adapters["pwa-node"] = {
						type = "server",
						host = "localhost",
						port = "${port}",
						executable = {
							command = "node",
							args = { js_debug_path, "${port}" },
						},
					}

					dap.adapters["node-terminal"] = dap.adapters["pwa-node"]
					dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

					local skip_files = { "<node_internals>/**", "**/node_modules/**" }
					local runtime_executable = (vim.env.DAP_BROWSER and vim.env.DAP_BROWSER ~= "") and vim.env.DAP_BROWSER or nil
				local attach_port = tonumber(vim.env.DAP_BROWSER_PORT) or 9222

					local function make_web_launch(name, url)
						return {
							type = "pwa-chrome",
							request = "launch",
							name = name,
							url = url,
							webRoot = get_workspace_root,
							skipFiles = skip_files,
							sourceMaps = true,
							runtimeExecutable = runtime_executable,
							address = "localhost",
						}
					end

					local function make_web_attach(name, port)
						return {
							type = "pwa-chrome",
							request = "attach",
							name = name,
							port = port,
							address = "localhost",
							webRoot = get_workspace_root,
							sourceMaps = true,
							skipFiles = skip_files,
							urlFilter = "http://localhost:*",
							runtimeExecutable = runtime_executable,
						}
					end

					local base_configs = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = get_workspace_root,
							runtimeExecutable = "node",
							sourceMaps = true,
							skipFiles = skip_files,
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach 9229",
							processId = require("dap.utils").pick_process,
							cwd = get_workspace_root,
							sourceMaps = true,
							port = 9229,
							skipFiles = skip_files,
						},
						make_web_launch("Launch Chrome: 3000", "http://localhost:3000"),
						make_web_launch("Launch Chrome: 5173", "http://localhost:5173"),
						make_web_attach("Attach Chrome: ${port}", attach_port),
					}

					for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
						dap.configurations[language] = vim.deepcopy(base_configs)
					end
				end

				local function resolve_from_mason()
					local ok, registry = pcall(require, "mason-registry")
					if not ok then
						return
					end

					local function configure()
						local ok_pkg, package = pcall(registry.get_package, "js-debug-adapter")
						if not ok_pkg or not package then
							return
						end

						if not package.is_installed or not package:is_installed() then
							if package.once then
								package:once("install:success", function()
									if package.get_install_path then
										configure_from_path(package:get_install_path() .. "/js-debug/src/dapDebugServer.js")
									end
								end)
							elseif package.on then
								package:on("install:success", function()
									if package.get_install_path then
										configure_from_path(package:get_install_path() .. "/js-debug/src/dapDebugServer.js")
									end
								end)
							end

							if package.install then
								package:install()
							end

							return
						end

						if type(package.get_install_path) ~= "function" then
							return
						end

						configure_from_path(package:get_install_path() .. "/js-debug/src/dapDebugServer.js")
					end

					if registry.refresh then
						registry.refresh(configure)
					else
						configure()
					end

					if registry.is_installed and registry.is_installed("js-debug-adapter") then
						configure()
					end
				end

				local function resolve_direct_path()
					local mason_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
					local stat = nil
					if vim.uv and vim.uv.fs_stat then
						stat = vim.uv.fs_stat(mason_path)
					elseif vim.loop and vim.loop.fs_stat then
						stat = vim.loop.fs_stat(mason_path)
					end

					if stat then
						return mason_path
					end
				end

				local direct_path = resolve_direct_path()
				if direct_path then
					configure_from_path(direct_path)
				else
					resolve_from_mason()
				end
			end

			setup_js_debug_adapters()

			Keymap.normal("<leader>dc", require("dap").continue)
			Keymap.normal("<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
			Keymap.normal("<leader>do", require("dap").step_over)
			Keymap.normal("<leader>di", require("dap").step_into)
			Keymap.normal("<leader>dO", require("dap").step_out)
			Keymap.normal("<leader>db", require("dap").toggle_breakpoint)
			Keymap.normal("<leader>dB",
				function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
			Keymap.normal("<leader>dh", function()
				local widgets = require("dap.ui.widgets")
				local hover_ui = require("utils.hover-ui")
				widgets.hover(nil, hover_ui.style)
			end, { desc = "DAP hover value" })
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		config = true,
		keys = {
			{
				"<leader>dd",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI"
			},
		},
		dependencies = {
			-- keep-sorted start block=yes
			{
				"jay-babu/mason-nvim-dap.nvim",
				---@type MasonNvimDapSettings
				opts = {
					handlers = {},
					automatic_installation = true,
					ensure_installed = { "js-debug-adapter" },
				},
				dependencies = {
					"mfussenegger/nvim-dap",
					"mason-org/mason.nvim",
				},
			}
		}
	}

}
