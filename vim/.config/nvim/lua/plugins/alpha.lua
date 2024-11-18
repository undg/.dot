return {
	'goolord/alpha-nvim', -- https://github.com/goolord/alpha-nvim
	config = function()
		local alpha_ok, alpha = pcall(require, 'alpha')
		local dashboard_ok, dashboard = pcall(require, 'alpha.themes.dashboard')
		local obsidian_util_ok, obsidian_util = pcall(require, 'plugins.obsidian-utils')

		local not_ok = not alpha_ok and 'alpha' --
			or not dashboard_ok and 'alpha.themes.dashboard'
			or not obsidian_util_ok and 'plugins.obsidian-util'
			or false

		if not_ok then
			vim.notify('plugins/alpha.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
			return
		end

		local function open_new_obsidian_work()
			local workspace = obsidian_util.workspaces.work
			local cmd = ':cd ' .. workspace.path .. '<cr>'
			cmd = cmd .. ':ObsidianWorkspace ' .. workspace.name .. '<cr>'
			cmd = cmd .. ':ObsidianToday<CR>'
			return cmd
		end

		local function open_new_obsidian_personal()
			local workspace = obsidian_util.workspaces.personal
			local cmd = ':cd ' .. workspace.path .. '<cr>'
			cmd = cmd .. ':ObsidianWorkspace ' .. workspace.name .. '<cr>'
			cmd = cmd .. ':ObsidianToday<CR>'
			return cmd
		end

		local function open_new_obsidian_wiki()
			local workspace = obsidian_util.workspaces.wiki
			local cmd = ':cd ' .. workspace.path .. '<cr>'
			cmd = cmd .. ':ObsidianWorkspace ' .. workspace.name .. '<cr>'
			cmd = cmd .. ':ObsidianToday<CR>'
			return cmd
		end

		local version = 'v' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch

		-- Set header
		dashboard.section.header.val = {
			'                                                     ',
			'                                                     ',
			'  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
			'  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
			'  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
			'  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
			'  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
			'  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
			'  ' .. version,
		}

		dashboard.section.buttons.val = {
			dashboard.button('sc', '鬒  >  Session (current dir)', ':SessionManager load_current_dir_session<CR>'),
			dashboard.button('o', '   >  Old files', ':Telescope oldfiles cwd_only=true<CR>'),
			dashboard.button('e', '   >  New file', ':enew <BAR> startinsert <CR>'),
			dashboard.button('gg', '🗪   >  ChatGPT', ':GpChatNew<CR>'),
			dashboard.button('gp', '🗪   >  ChatGPT (proofread)', ':GpProofread<CR>'),
			dashboard.button('w', '🖋  >  Note Work', open_new_obsidian_work()),
			dashboard.button('p', '󱦹   >  Note Personal', open_new_obsidian_personal()),
			dashboard.button('ss', '   >  Sessions list', ':SessionManager load_session<CR>'),
			dashboard.button('f', '   >  Find files', ':Telescope find_files<CR>'),
			dashboard.button('q', '   >  Quit', ':qa<CR>'),
			dashboard.button('<C-c>', '', ':qa<CR>'),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		Keymap.normal('<leader>sl', ':SessionManager load_last_session<CR>')
		Keymap.normal('<leader>ss', ':SessionManager load_session<CR>')
		Keymap.normal('<leader>sc', ':SessionManager load_current_dir_session<CR>')
		Keymap.normal('<leader>sw', ':SessionManager save_current_session<CR>')
	end,
}
