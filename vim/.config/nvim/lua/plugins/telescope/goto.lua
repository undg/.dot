local ok_telescope, telescope = pcall(require, 'telescope')
local ok_tb, tb = pcall(require, 'telescope.builtin')

if not ok_telescope or not ok_tb then
    print('plugins/telescope/goto: missing requirements')
    return
end

-- Goto mapins to specific folders
vim.api.nvim_create_user_command('GotoVimFind',   "lua require('plugins.telescope.goto').vim().find()", {})
vim.api.nvim_create_user_command('GotoVimBrowse', "lua require('plugins.telescope.goto').vim().browse()", {})
vim.api.nvim_create_user_command('GotoVimGrep',   "lua require('plugins.telescope.goto').vim().grep()", {})
vim.api.nvim_create_user_command('GotoVimGit',    "lua require('plugins.telescope.goto').vim().git()", {})

vim.api.nvim_create_user_command('GotoZshFind',   "lua require('plugins.telescope.goto').zsh().find()", {})
vim.api.nvim_create_user_command('GotoZshBrowse', "lua require('plugins.telescope.goto').zsh().browse()", {})
vim.api.nvim_create_user_command('GotoZshGrep',   "lua require('plugins.telescope.goto').zsh().grep()", {})
vim.api.nvim_create_user_command('GotoZshGit',    "lua require('plugins.telescope.goto').zsh().git()", {})

vim.api.nvim_create_user_command('GotoDotFind',   "lua require('plugins.telescope.goto').dot().find", {})
vim.api.nvim_create_user_command('GotoDotBrowse', "lua require('plugins.telescope.goto').dot().browse()", {})
vim.api.nvim_create_user_command('GotoDotGrep',   "lua require('plugins.telescope.goto').dot().grep()", {})
vim.api.nvim_create_user_command('GotoDotGit',    "lua require('plugins.telescope.goto').dot().git()", {})

vim.api.nvim_create_user_command('GotoCodeFind',   "lua require('plugins.telescope.goto').code().find", {})
vim.api.nvim_create_user_command('GotoCodeBrowse', "lua require('plugins.telescope.goto').code().browse()", {})
vim.api.nvim_create_user_command('GotoCodeGrep',   "lua require('plugins.telescope.goto').code().grep()", {})
vim.api.nvim_create_user_command('GotoCodeGit',    "lua require('plugins.telescope.goto').code().git()", {})

vim.api.nvim_create_user_command('GotoHmrcFind',   "lua require('plugins.telescope.goto').hmrc().find", {})
vim.api.nvim_create_user_command('GotoHmrcBrowse', "lua require('plugins.telescope.goto').hmrc().browse()", {})
vim.api.nvim_create_user_command('GotoHmrcGrep',   "lua require('plugins.telescope.goto').hmrc().grep()", {})
vim.api.nvim_create_user_command('GotoHmrcGit',    "lua require('plugins.telescope.goto').hmrc().git()", {})

local M = {}
local T = {}

function T.find()
    tb.find_files({ hidden = true })
end
function T.browse()
    telescope.extensions.file_browser.file_browser({ hidden = true })
end
function T.git()
    tb.git_status({ hidden = true })
end
function T.grep()
    tb.live_grep({ hidden = true })
end

function M.vim()
    vim.cmd([[ :cd  ~/.dot/vim/.config/nvim/ ]])
    return T
end

function M.zsh()
    vim.cmd([[ :cd  ~/.dot/zsh/.config/zsh ]])
    return T
end

function M.dot()
    vim.cmd([[ :cd  ~/.dot/ ]])
    return T
end

function M.code()
    vim.cmd([[ :cd  ~/Code/ ]])
    return T
end

return M
