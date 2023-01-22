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
    dashboard.button('sl', '   >  Last session', ':SessionManager load_last_session<CR>'),
    dashboard.button('ss', '   >  Sessions list', ':SessionManager load_session<CR>'),
    dashboard.button('pp', '⌨   >  Projects', ':Telescope project<CR>'),
    dashboard.button('ff', '   >  Find files', ':Telescope find_files<CR>'),
    dashboard.button('fd', '   >  Dot find files', ':cd ~/.dot/ |  Telescope find_files cwd_only=true<CR>'),
    dashboard.button('fv', '   >  Nvim find files', ':cd ~/.config/nvim/ | Telescope find_files cwd_only=true<CR>'),
    dashboard.button('oo', '   >  Old files', ':Telescope oldfiles cwd_only=true<CR>'),
    dashboard.button('ov', '   >  Nvim old files', ':cd ~/.config/nvim/ | Telescope oldfiles cwd_only=true<CR>'),
    dashboard.button('od', '   >  Dot old files', ':cd ~/.dot/ |  Telescope oldfiles cwd_only=true<CR>'),
    dashboard.button( 'e', '   >  New file', ':enew <BAR> startinsert <CR>'),
    dashboard.button( 'q', '   >  Quit', ':qa<CR>'),
    dashboard.button('<C-c>', '', ':qa<CR>'),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

local map = require('utils.map')

map.normal('<leader>sl', ':SessionManager load_last_session<CR>')
map.normal('<leader>ss', ':SessionManager load_session<CR>')
map.normal('<leader>sc', ':SessionManager load_current_dir_session<CR>')
map.normal('<leader>sw', ':SessionManager save_current_session<CR>')
