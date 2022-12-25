local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

dashboard.section.buttons.val = {
    dashboard.button( "r", "   >  Recent here", ":Telescope oldfiles cwd_only=true <CR>"),
    dashboard.button( "c", "   >  Recent"     , ":Telescope oldfiles<CR>"),
    dashboard.button( "p", "⌨   >  Projects"   , ":Telescope project<CR>"),
    dashboard.button( "f", "   >  Find file"  , ":Telescope find_files<CR>"),
    dashboard.button( "s", "   >  Settings"   , ":e $MYVIMRC | lcd %:p:h | Telescope oldfiles cwd_only=true<CR>"),
    dashboard.button( "d", "   >  Dot"        , ":e $HOME/.dot/README.md | Telescope find_files hidden=true no_ignore=true<CR>"),
    dashboard.button( "e", "   >  New file"   , ":enew <BAR> startinsert <CR>"),
    dashboard.button( "q", "   >  Quit NVIM"  , ":qa<CR>"),
    dashboard.button( "<C-c>", ""              , ":qa<CR>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

