return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim',  build = 'make' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-telescope/telescope-project.nvim' }, -- quick access to saved projects paths.
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

            -- keymaps
            local map = require('utils.map')
            local getVisualSelectionFn = require('custom/get-visual-selection')
            local tb = require('telescope.builtin')
            local opts = { noremap = true, silent = true }

            -- Core
            map.normal('<leader>m', ':Telescope<cr>')
            map.normal(',.', ':Telescope find_files hidden=true<cr>')
            map.normal('<leader>,', ':Telescope find_files hidden=true<cr>')
            map.normal(
                '<leader>.',
                ':lua require("telescope").extensions.file_browser.file_browser({hidden = true, path = "%:p:h", grouped = true, hide_parent_dir = true, select_buffer = true, respect_gitignore = true })<cr>'
            )

            map.normal('<leader>fb', ':Telescope buffers<cr>')
            map.normal('<leader>fg', ':Telescope live_grep<cr>')
            map.normal('<leader>fr', ':Telescope resume<cr>')
            map.normal('<leader>fq', ':Telescope quickfixhistory<cr>')
            map.normal('<leader>fp', ':Telescope project<cr>')
            map.normal('<leader>fo', ':Telescope oldfiles cwd_only=true<cr>')
            map.normal('<leader>fh', ':Telescope help_tags<cr>')
            map.normal('<leader>fm', ':Telescope keymaps<cr>')
            map.normal('<leader>fc', ':Telescope commands<cr>')

            -- Custom goto commands
            map.normal('<leader>ve', ':GotoVimFind<cr>')
            map.normal('<leader>fvf', ':GotoVimFind<cr>')
            map.normal('<leader>fvb', ':GotoVimBrowse<cr>')
            map.normal('<leader>fvs', ':GotoVimGit<cr>')
            map.normal('<leader>fvg', ':GotoVimGrep<cr>')

            map.normal('<leader>fzf', ':GotoZshFind<cr>')
            map.normal('<leader>fzb', ':GotoZshBrowse<cr>')
            map.normal('<leader>fzs', ':GotoZshGit<cr>')
            map.normal('<leader>fzg', ':GotoZshGrep<cr>')

            map.normal('<leader>fdf', ':GotoDotFind<cr>')
            map.normal('<leader>fdb', ':GotoDotBrowse<cr>')
            map.normal('<leader>fds', ':GotoDotGit<cr>')
            map.normal('<leader>fdg', ':GotoDotGrep<cr>')

            map.normal('<leader>fcf', ':GotoCodeFind<cr>')
            map.normal('<leader>fcb', ':GotoCodeBrowse<cr>')
            map.normal('<leader>fcs', ':GotoCodeGit<cr>')
            map.normal('<leader>fcg', ':GotoCodeGrep<cr>')

            map.visual('<leader>fg', function()
                tb.live_grep({ default_text = getVisualSelectionFn() })
            end, opts)
        end,
    },
}
