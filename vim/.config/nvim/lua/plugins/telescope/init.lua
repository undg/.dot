local map = require('utils.map')

require("telescope.actions")
local trouble = require("trouble.providers.telescope")



require('telescope').setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key",
                ["<c-p>"] = trouble.open_with_trouble ,
            },
            n = { ["<c-p>"] = trouble.open_with_trouble },
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        -- You dont need to set any of these options. These are the default ones. Only
        -- the loading is important
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

vim.cmd [[command! GotoVimFind :lua R('plugins.telescope.goto').vim().find()<cr>]]
vim.cmd [[command! GotoVimBrowse :lua R('plugins.telescope.goto').vim().browse()<cr>]]
vim.cmd [[command! GotoVimGrep :lua R('plugins.telescope.goto').vim().grep()<cr>]]
vim.cmd [[command! GotoVimGit :lua R('plugins.telescope.goto').vim().git()<cr>]]

vim.cmd [[command! GotoZshFind :lua R('plugins.telescope.goto').zsh().find()<cr>]]
vim.cmd [[command! GotoZshBrowse :lua R('plugins.telescope.goto').zsh().browse()<cr>]]
vim.cmd [[command! GotoZshGrep :lua R('plugins.telescope.goto').zsh().grep()<cr>]]
vim.cmd [[command! GotoZshGit :lua R('plugins.telescope.goto').zsh().git()<cr>]]

vim.cmd [[command! GotoDotFind :lua R('plugins.telescope.goto').dot().find<cr>]]
vim.cmd [[command! GotoDotBrowse :lua R('plugins.telescope.goto').dot().browse()<cr>]]
vim.cmd [[command! GotoDotGrep :lua R('plugins.telescope.goto').dot().grep()<cr>]]
vim.cmd [[command! GotoDotGit :lua R('plugins.telescope.goto').dot().git()<cr>]]

vim.cmd [[command! GotoCodeFind :lua R('plugins.telescope.goto').code().find<cr>]]
vim.cmd [[command! GotoCodeBrowse :lua R('plugins.telescope.goto').code().browse()<cr>]]
vim.cmd [[command! GotoCodeGrep :lua R('plugins.telescope.goto').code().grep()<cr>]]
vim.cmd [[command! GotoCodeGit :lua R('plugins.telescope.goto').code().git()<cr>]]

vim.cmd [[command! GotoHmrcFind :lua R('plugins.telescope.goto').hmrc().find<cr>]]
vim.cmd [[command! GotoHmrcBrowse :lua R('plugins.telescope.goto').hmrc().browse()<cr>]]
vim.cmd [[command! GotoHmrcGrep :lua R('plugins.telescope.goto').hmrc().grep()<cr>]]
vim.cmd [[command! GotoHmrcGit :lua R('plugins.telescope.goto').hmrc().git()<cr>]]

map.normal('fvf', ':GotoVimFind<cr>')
map.normal('fvb', ':GotoVimBrowse<cr>')
map.normal('fvs', ':GotoVimGit<cr>')
map.normal('fvg', ':GotoVimGrep<cr>')

map.normal('fzf', ':GotoZshFind<cr>')
map.normal('fzb', ':GotoZshBrowse<cr>')
map.normal('fzs', ':GotoZshGit<cr>')
map.normal('fzg', ':GotoZshGrep<cr>')

map.normal('fdf', ':GotoDotFind<cr>')
map.normal('fdb', ':GotoDotBrowse<cr>')
map.normal('fds', ':GotoDotGit<cr>')
map.normal('fdg', ':GotoDotGrep<cr>')

map.normal('fcf', ':GotoCodeFind<cr>')
map.normal('fcb', ':GotoCodeBrowse<cr>')
map.normal('fcs', ':GotoCodeGit<cr>')
map.normal('fcg', ':GotoCodeGrep<cr>')

-- Core
map.normal('<leader>.', ':Telescope find_files<cr>')
map.normal('<leader>m', ':Telescope<cr>')
map.normal('ft', ':Telescope<cr>')
map.normal('<leader>b', ':Telescope buffers<cr>')
map.normal('fg', ':Telescope live_grep<cr>')
map.normal('fb', ':Telescope file_browser<cr>')
map.normal('fs', ':Telescope git_status<cr>')

-- map.normal('<leader>', ':Telescope<cr>')
-- map.normal('<leader>', ':Telescope<cr>')
