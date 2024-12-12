return {
	"goolord/alpha-nvim", -- https://github.com/goolord/alpha-nvim
	config = function()
		local alpha_ok, alpha = pcall(require, "alpha")
		local dashboard_ok, dashboard = pcall(require, "alpha.themes.dashboard")
		local obsidian_util_ok, obsidian_util = pcall(require, "plugins.obsidian-utils")

		local not_ok = not alpha_ok and "alpha" --
			or not dashboard_ok and "alpha.themes.dashboard"
			or not obsidian_util_ok and "plugins.obsidian-util"
			or false

		if not_ok then
			vim.notify("plugins/alpha.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		---Runs new Obsidian note in the work workspace
		---@param command string|nil Additional command to execute after opening the note
		---@return string The complete Vim command string
		local function cmd_obsidian_work(command)
			local workspace = obsidian_util.workspaces.work
			local cmd = ":cd " .. workspace.path .. "<cr>"
			cmd = cmd .. ":ObsidianWorkspace " .. workspace.name .. "<cr>"
			if command then
				cmd = cmd .. command
			end
			return cmd
		end

		---Runs new Obsidian note in the personal workspace
		---@param command string|nil Additional command to execute after opening the note
		---@return string The complete Vim command string
		local function cmd_obsidian_personal(command)
			local workspace = obsidian_util.workspaces.personal
			local cmd = ":cd " .. workspace.path .. "<cr>"
			cmd = cmd .. ":ObsidianWorkspace " .. workspace.name .. "<cr>"
			if command then
				cmd = cmd .. command
			end
			return cmd
		end

		local version = "v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch

		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"  " .. version,
		}

		dashboard.section.buttons.val = {
			dashboard.button("sc", "鬒  >  Session (current dir)", ":SessionManager load_current_dir_session<CR>"),
			dashboard.button("o", "   >  Old files", ":Telescope oldfiles cwd_only=true<CR>"),
			dashboard.button("e", "   >  New file", ":enew <BAR> startinsert <CR>"),
			dashboard.button("f", "   >  Find files", ":Telescope find_files<CR>"),
			dashboard.button("w", "🖋  >  Note Work", cmd_obsidian_work(":ObsidianToday<CR>")),
			dashboard.button("p", "󱦹   >  Note Personal", cmd_obsidian_personal(":ObsidianToday<CR>")),
			dashboard.button("t", "☑   >  Todo Personal", cmd_obsidian_personal(":e todo.md<CR>")),
			dashboard.button("gg", "🗪   >  Ai", ":AiChatNew<CR>"),
			dashboard.button("gp", "🗪   >  Ai (proofread)", ":AiProofread<CR>"),
			dashboard.button("ss", "   >  Sessions list", ":SessionManager load_session<CR>"),
			dashboard.button("q", "   >  Quit", ":qa<CR>"),
			dashboard.button("<C-c>", "", ":qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		Keymap.normal("<leader>sl", ":SessionManager load_last_session<CR>")
		Keymap.normal("<leader>ss", ":SessionManager load_session<CR>")
		Keymap.normal("<leader>sc", ":SessionManager load_current_dir_session<CR>")
		Keymap.normal("<leader>sw", ":SessionManager save_current_session<CR>")
	end,
}
