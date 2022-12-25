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
    dashboard.button( "p", "⌨   >  Projects" , ":Telescope project<CR>"),
    dashboard.button( "r", "   >  Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "e", "   >  New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "   >  Find file", ":cd $HOME/ | Telescope find_files<CR>"),
    dashboard.button( "s", "   >  Settings" , ":e $MYVIMRC | lcd %:p:h | Telescope find_files hidden=true no_ignore=true<CR>"),
    dashboard.button( "d", "   >  Dot"      , ":cd $HOME/.dot/ | Telescope find_files hidden=true no_ignore=true<CR>"),
    dashboard.button( "q", "   >  Quit NVIM", ":qa<CR>"),
    dashboard.button( "<C-c>", "", ":qa<CR>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

