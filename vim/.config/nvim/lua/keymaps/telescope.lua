local map = require("utils.map")
local getVisualSelectionFn = require("custom/get-visual-selection")
local tb = require("telescope.builtin")
local opts = { noremap = true, silent = true }

-- Core
map.normal("<leader>m", ":Telescope<cr>")
map.normal(",.",        ":Telescope find_files hidden=true<cr>")
map.normal("<leader>,", ":Telescope find_files hidden=true<cr>")
map.normal( "<leader>.",
    ':lua require("telescope").extensions.file_browser.file_browser({hidden = true, path = "%:p:h", grouped = true, hide_parent_dir = true, select_buffer = true, respect_gitignore = true })<cr>'
)
map.normal("<leader>fb", ":Telescope buffers<cr>")
map.normal("<leader>fg", ":Telescope live_grep<cr>")
map.normal("<leader>fr", ":Telescope resume<cr>")
map.normal("<leader>fs", ":Telescope git_status<cr>")
map.normal("<leader>fq", ":Telescope quickfixhistory<cr>")
map.normal("<leader>fp", ":Telescope project<cr>")
map.normal("<leader>fo", ":Telescope oldfiles cwd_only=true<cr>")
map.normal("<leader>fh", ":Telescope help_tags<cr>")
map.normal("<leader>fk", ":Telescope keymaps<cr>")

-- Custom goto commands
map.normal("<leader>ve", ":GotoVimFind<cr>")
map.normal("<leader>fvf", ":GotoVimFind<cr>")
map.normal("<leader>fvb", ":GotoVimBrowse<cr>")
map.normal("<leader>fvs", ":GotoVimGit<cr>")
map.normal("<leader>fvg", ":GotoVimGrep<cr>")

map.normal("<leader>fzf", ":GotoZshFind<cr>")
map.normal("<leader>fzb", ":GotoZshBrowse<cr>")
map.normal("<leader>fzs", ":GotoZshGit<cr>")
map.normal("<leader>fzg", ":GotoZshGrep<cr>")

map.normal("<leader>fdf", ":GotoDotFind<cr>")
map.normal("<leader>fdb", ":GotoDotBrowse<cr>")
map.normal("<leader>fds", ":GotoDotGit<cr>")
map.normal("<leader>fdg", ":GotoDotGrep<cr>")

map.normal("<leader>fcf", ":GotoCodeFind<cr>")
map.normal("<leader>fcb", ":GotoCodeBrowse<cr>")
map.normal("<leader>fcs", ":GotoCodeGit<cr>")
map.normal("<leader>fcg", ":GotoCodeGrep<cr>")

map.visual("<leader>fg", function()
    tb.live_grep({ default_text = getVisualSelectionFn() })
end, opts)
