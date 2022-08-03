local map = require("utils.map")

-- Core
map.normal("<leader>m", ":Telescope<cr>")
map.normal("ft", ":Telescope<cr>")
map.normal(",.", ":Telescope find_files hidden=true<cr>")
map.normal("<leader>,", ":Telescope find_files hidden=true<cr>")
map.normal("<leader>.", ':lua require("telescope").extensions.file_browser.file_browser({hidden = true, path = "%:p:h", grouped = true, hide_parent_dir = true, select_buffer = true, respect_gitignore = true })<cr>')
map.normal("fb", ":Telescope buffers<cr>")
map.normal("fg", ":Telescope live_grep<cr>")
map.normal("fs", ":Telescope git_status<cr>")
map.normal("fq", ":Telescope quickfixhistory<cr>")

-- Custom commands
map.normal("fvf", ":GotoVimFind<cr>")
map.normal("fvb", ":GotoVimBrowse<cr>")
map.normal("fvs", ":GotoVimGit<cr>")
map.normal("fvg", ":GotoVimGrep<cr>")

map.normal("fzf", ":GotoZshFind<cr>")
map.normal("fzb", ":GotoZshBrowse<cr>")
map.normal("fzs", ":GotoZshGit<cr>")
map.normal("fzg", ":GotoZshGrep<cr>")

map.normal("fdf", ":GotoDotFind<cr>")
map.normal("fdb", ":GotoDotBrowse<cr>")
map.normal("fds", ":GotoDotGit<cr>")
map.normal("fdg", ":GotoDotGrep<cr>")

map.normal("fcf", ":GotoCodeFind<cr>")
map.normal("fcb", ":GotoCodeBrowse<cr>")
map.normal("fcs", ":GotoCodeGit<cr>")
map.normal("fcg", ":GotoCodeGrep<cr>")

