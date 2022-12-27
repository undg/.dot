local alpha_ok, alpha = pcall(require, 'alpha')
if not alpha_ok then
    print('lua/plugins/alpha.lua: alpha fail to load')
    return
end

local dashboard_ok, dashboard = pcall(require, 'alpha.themes.dashboard')
if not dashboard_ok then
    print('lua/plugins/alpha.lua: alpha.themes.dashboard fail to load')
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
    dashboard.button('sl', '   >  Last session', ':SessionManager load_last_session<CR>'),
    dashboard.button('ss', '   >  Sessions list', ':SessionManager load_session<CR>'),
    dashboard.button('sc', '鬒  >  Session (current dir)', ':SessionManager load_current_dir_session<CR>'),
    dashboard.button('fo', '   >  Recent', ':Telescope oldfiles<CR>'),
    dashboard.button('fp', '⌨   >  Projects', ':Telescope project<CR>'),
    dashboard.button(',.', '   >  Find file', ':Telescope find_files<CR>'),
    dashboard.button('v', '   >  Nvim Settings', ':cd ~/.config/nvim/ | Telescope oldfiles cwd_only=true<CR>'),
    dashboard.button('d', '   >  Dot', ':e $HOME/.dot/ | Telescope find_files hidden=true no_ignore=true<CR>'),
    dashboard.button('e', '   >  New file', ':enew <BAR> startinsert <CR>'),
    dashboard.button('q', '   >  Quit NVIM', ':qa<CR>'),
    dashboard.button('<C-c>', '', ':qa<CR>'),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

local map = require('utils.map')

map.normal('<leader>sl', ':SessionManager load_last_session<CR>')
map.normal('<leader>ss', ':SessionManager load_session<CR>')
map.normal('<leader>sc', ':SessionManager load_current_dir_session<CR>')
map.normal('<leader>sw', ':SessionManager save_current_session<CR>')
