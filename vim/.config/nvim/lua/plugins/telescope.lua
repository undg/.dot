return {

    { 'nvim-telescope/telescope-project.nvim' }, -- quick access to saved projects paths.
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim',  build = 'make' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            {
                'ThePrimeagen/harpoon',
                config = function()
                    local ok_harpoon, harpoon = pcall(require, 'harpoon')
                    if not ok_harpoon then
                        print('plugins/harpoon.lua: missing requirement')
                        return
                    end

                    harpoon.setup({
                        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                        save_on_toggle = true,

                        -- saves the harpoon file upon every change. disabling is unrecommended.
                        save_on_change = true,

                        -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                        enter_on_sendcmd = false,

                        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                        tmux_autoclose_windows = false,

                        -- filetypes that you want to prevent from adding to the harpoon list menu.
                        excluded_filetypes = { 'harpoon' },

                        -- set marks specific to each git branch inside git repository
                        mark_branch = false,
                        menu = {
                            width = vim.api.nvim_win_get_width(0) - 20,
                        },
                    })
                end,
            },
        },
        config = function()
            local ok_telescope, telescope = pcall(require, 'telescope')
            local ok_actions, actions = pcall(require, 'telescope.actions')

            if not ok_telescope or not ok_actions then
                print('plugins/telescope/goto: missing requirements')
                return
            end

            local fb_actions = telescope.extensions.file_browser.actions
            -- local trouble = require("trouble.providers.telescope")

            telescope.setup({
                defaults = {
                    -- Default configuration for telescope goes here:
                    -- config_key = value,
                    layout_strategy = 'vertical',
                    layout_config = { height = 0.9, width = 0.9 },
                    mappings = {
                        i = {
                            ['<C-n>'] = actions.move_selection_next,
                            ['<C-j>'] = actions.move_selection_next,
                            ['<Down>'] = actions.move_selection_next,
                            ['<C-p>'] = actions.move_selection_previous,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<Up>'] = actions.move_selection_previous,

                            ['<CR>'] = actions.select_default,
                            ['<C-l>'] = actions.select_default,

                            ['<C-x>'] = actions.select_horizontal,
                            ['<C-v>'] = actions.select_vertical,
                            ['<C-t>'] = actions.select_tab,

                            ['<C-u>'] = nil,
                            ['<PageUp>'] = actions.results_scrolling_up,
                            ['<C-d>'] = nil,
                            ['<PageDown>'] = actions.results_scrolling_down,

                            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                            ['<C-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                            ['<C-S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                            ['<C- >'] = actions.toggle_selection,

                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                            -- ["<C-l>"] = actions.complete_tag,
                            ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
                            ['<C-w>'] = { '<c-s-w>', type = 'command' },

                            ['<esc>'] = actions.close,
                            ['<C-c>'] = actions.close,
                            ['<C-m>'] = nil,
                        },
                    },
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
                    -- the load is important
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    file_browser = {
                        -- theme = "ivy",
                        layout_strategy = 'vertical',
                        layout_config = { height = 0.9, width = 0.9 },
                        mappings = {
                            i = {
                                ['<C-i>'] = fb_actions.toggle_hidden,
                                ['<C-h>'] = fb_actions.goto_parent_dir,
                                ['<C-c>'] = fb_actions.create,
                                ['<C-n>'] = fb_actions.rename,
                                ['<C-d>'] = fb_actions.remove,
                                ['<C-a>'] = fb_actions.select_all,
                            },
                        },
                    },

                    project = {
                        hidden_files = true,
                        search_by = 'title',
                        sync_with_nvim_tree = true,
                    },
                },
            })

            -- load_extension's, somewhere after setup function:
            telescope.load_extension('fzf')
            telescope.load_extension('file_browser')
            telescope.load_extension('ui-select')
            telescope.load_extension('harpoon')
            telescope.load_extension('project')

            -- wrapper with goto commands
            local ok_tb, tb = pcall(require, 'telescope.builtin')

            if not ok_telescope or not ok_tb then
                print('plugins/telescope/goto: missing requirements')
                return
            end

            -- Goto mapins to specific folders
            vim.api.nvim_create_user_command('GotoVimFind', "lua require('plugins.telescope.goto').vim().find()", {})
            vim.api.nvim_create_user_command(
                'GotoVimBrowse',
                "lua require('plugins.telescope.goto').vim().browse()",
                {}
            )
            vim.api.nvim_create_user_command('GotoVimGrep', "lua require('plugins.telescope.goto').vim().grep()", {})
            vim.api.nvim_create_user_command('GotoVimGit', "lua require('plugins.telescope.goto').vim().git()", {})

            vim.api.nvim_create_user_command('GotoZshFind', "lua require('plugins.telescope.goto').zsh().find()", {})
            vim.api.nvim_create_user_command(
                'GotoZshBrowse',
                "lua require('plugins.telescope.goto').zsh().browse()",
                {}
            )
            vim.api.nvim_create_user_command('GotoZshGrep', "lua require('plugins.telescope.goto').zsh().grep()", {})
            vim.api.nvim_create_user_command('GotoZshGit', "lua require('plugins.telescope.goto').zsh().git()", {})

            vim.api.nvim_create_user_command('GotoDotFind', "lua require('plugins.telescope.goto').dot().find", {})
            vim.api.nvim_create_user_command(
                'GotoDotBrowse',
                "lua require('plugins.telescope.goto').dot().browse()",
                {}
            )
            vim.api.nvim_create_user_command('GotoDotGrep', "lua require('plugins.telescope.goto').dot().grep()", {})
            vim.api.nvim_create_user_command('GotoDotGit', "lua require('plugins.telescope.goto').dot().git()", {})

            vim.api.nvim_create_user_command('GotoCodeFind', "lua require('plugins.telescope.goto').code().find", {})
            vim.api.nvim_create_user_command(
                'GotoCodeBrowse',
                "lua require('plugins.telescope.goto').code().browse()",
                {}
            )
            vim.api.nvim_create_user_command('GotoCodeGrep', "lua require('plugins.telescope.goto').code().grep()", {})
            vim.api.nvim_create_user_command('GotoCodeGit', "lua require('plugins.telescope.goto').code().git()", {})

            vim.api.nvim_create_user_command('GotoHmrcFind', "lua require('plugins.telescope.goto').hmrc().find", {})
            vim.api.nvim_create_user_command(
                'GotoHmrcBrowse',
                "lua require('plugins.telescope.goto').hmrc().browse()",
                {}
            )
            vim.api.nvim_create_user_command('GotoHmrcGrep', "lua require('plugins.telescope.goto').hmrc().grep()", {})
            vim.api.nvim_create_user_command('GotoHmrcGit', "lua require('plugins.telescope.goto').hmrc().git()", {})

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
        end,
    },
}
