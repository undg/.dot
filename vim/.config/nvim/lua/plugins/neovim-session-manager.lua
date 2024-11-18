-- https://github.com/Shatur/neovim-session-manager

return {
	'Shatur/neovim-session-manager',
	config = function()
		local session_manager_ok, session_manager = pcall(require, 'session_manager')
		local path_ok, path = pcall(require, 'plenary.path')
		local config_ok, config = pcall(require, 'session_manager.config')

		local not_ok = not session_manager_ok and 'session_manager' --
			or not path_ok and 'plenary.path'
			or not config_ok and 'session_manager.config'
			or false

		if not_ok then
			vim.notify(
				'lua/plugins/neovim-session-manager.lua: missing requirements - ' .. not_ok,
				vim.log.levels.ERROR
			)
			return
		end

		session_manager.setup({
			sessions_dir = path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
			autoload_mode = config.AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. See "Autoload mode" section below.
			autosave_last_session = true, -- Automatically save last session on exit and on session switch.
			autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
			autosave_ignore_dirs = { '.ssh' }, -- A list of directories where the session will not be autosaved.
			autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
				'gitcommit',
				'gitrebase',
			},
			autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
			autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
			max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
		})
	end,
}
