local keymap = require('utils.keymap')
return {
    'goolord/alpha-nvim',
    config = function()
        local ok_alpha, alpha = pcall(require, 'alpha')
        local ok_dashboard, dashboard = pcall(require, 'alpha.themes.dashboard')

        if not ok_alpha or not ok_dashboard then
            print('lua/plugins/alpha.lua: missing requirements')
            return
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
            dashboard.button( 'g', '🗪   >  ChatGPT', ':GpChatNew<CR>'),
            dashboard.button( 'e', '   >  New file', ':enew <BAR> startinsert <CR>'),
            dashboard.button('o', '   >  Old files', ':Telescope oldfiles cwd_only=true<CR>'),
            dashboard.button('ss', '   >  Sessions list', ':SessionManager load_session<CR>'),
            dashboard.button('f', '   >  Find files', ':Telescope find_files<CR>'),
            dashboard.button( 'q', '   >  Quit', ':qa<CR>'),
            dashboard.button('<C-c>', '', ':qa<CR>'),
        }

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        keymap.normal('<leader>sl', ':SessionManager load_last_session<CR>')
        keymap.normal('<leader>ss', ':SessionManager load_session<CR>')
        keymap.normal('<leader>sc', ':SessionManager load_current_dir_session<CR>')
        keymap.normal('<leader>sw', ':SessionManager save_current_session<CR>')
    end,
}
