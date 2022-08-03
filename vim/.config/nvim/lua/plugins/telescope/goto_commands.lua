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
