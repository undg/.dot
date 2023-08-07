return {
    'Shatur/neovim-session-manager',
    config = function()
        local ok_session_manager, session_manager = pcall(require, 'session_manager')
        local ok_path, path = pcall(require, 'plenary.path')
        local ok_config, _ = pcall(require, 'session_manager.config')

        if not ok_session_manager or not ok_path or not ok_config then
            print('lua/plugins/neovim-session-manager.lua: missing requirements')
            return
        end

        ---@param mode 'Disabled'|'CurrentDir'|'LastSession'
        function AutoloadModeName(mode)
            return mode
        end

        session_manager.setup({
            sessions_dir = path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
            path_replacer = '__',                                        -- The character to which the path separator will be replaced for session files.
            colon_replacer = '++',                                       -- The character to which the colon symbol will be replaced for session files.
            autoload_mode = AutoloadModeName('Disabled'),                -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
            autosave_last_session = true,                                -- Automatically save last session on exit and on session switch.
            autosave_ignore_not_normal = true,                           -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
            autosave_ignore_dirs = { '.ssh' },                           -- A list of directories where the session will not be autosaved.
            autosave_ignore_filetypes = {                                -- All buffers of these file types will be closed before the session is saved.
                'gitcommit',
            },
            autosave_ignore_buftypes = {},    -- All buffers of these bufer types will be closed before the session is saved.
            autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
            max_path_length = 80,             -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
        })
    end,
}
