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

-- map.normal('<leader>', ':Telescope<cr>')
-- map.normal('<leader>', ':Telescope<cr>')

-- Goto mapins to specific folders
vim.api.nvim_create_user_command('GotoVimFind',   "lua R('plugins.telescope.goto').vim().find()", {})
vim.api.nvim_create_user_command('GotoVimBrowse', "lua R('plugins.telescope.goto').vim().browse()", {})
vim.api.nvim_create_user_command('GotoVimGrep',   "lua R('plugins.telescope.goto').vim().grep()", {})
vim.api.nvim_create_user_command('GotoVimGit',    "lua R('plugins.telescope.goto').vim().git()", {})

vim.api.nvim_create_user_command('GotoZshFind',   "lua R('plugins.telescope.goto').zsh().find()", {})
vim.api.nvim_create_user_command('GotoZshBrowse', "lua R('plugins.telescope.goto').zsh().browse()", {})
vim.api.nvim_create_user_command('GotoZshGrep',   "lua R('plugins.telescope.goto').zsh().grep()", {})
vim.api.nvim_create_user_command('GotoZshGit',    "lua R('plugins.telescope.goto').zsh().git()", {})

vim.api.nvim_create_user_command('GotoDotFind',   "lua R('plugins.telescope.goto').dot().find", {})
vim.api.nvim_create_user_command('GotoDotBrowse', "lua R('plugins.telescope.goto').dot().browse()", {})
vim.api.nvim_create_user_command('GotoDotGrep',   "lua R('plugins.telescope.goto').dot().grep()", {})
vim.api.nvim_create_user_command('GotoDotGit',    "lua R('plugins.telescope.goto').dot().git()", {})

vim.api.nvim_create_user_command('GotoCodeFind',   "lua R('plugins.telescope.goto').code().find", {})
vim.api.nvim_create_user_command('GotoCodeBrowse', "lua R('plugins.telescope.goto').code().browse()", {})
vim.api.nvim_create_user_command('GotoCodeGrep',   "lua R('plugins.telescope.goto').code().grep()", {})
vim.api.nvim_create_user_command('GotoCodeGit',    "lua R('plugins.telescope.goto').code().git()", {})

vim.api.nvim_create_user_command('GotoHmrcFind',   "lua R('plugins.telescope.goto').hmrc().find", {})
vim.api.nvim_create_user_command('GotoHmrcBrowse', "lua R('plugins.telescope.goto').hmrc().browse()", {})
vim.api.nvim_create_user_command('GotoHmrcGrep',   "lua R('plugins.telescope.goto').hmrc().grep()", {})
vim.api.nvim_create_user_command('GotoHmrcGit',    "lua R('plugins.telescope.goto').hmrc().git()", {})

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
