return {
    {
        'nvim-telescope/telescope.nvim',                                    -- https://github.com/nvim-telescope/telescope.nvim
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
            'nvim-telescope/telescope-file-browser.nvim',                   -- https://github.com/nvim-telescope/telescope-file-browser.nvim
            'nvim-telescope/telescope-ui-select.nvim',                      -- https://github.com/nvim-telescope/telescope-ui-select.nvim
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
                pickers = {},
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    file_browser = {
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
                },
            })

            -- load_extension's, somewhere after setup function:
            telescope.load_extension('fzf')
            telescope.load_extension('file_browser')
            telescope.load_extension('ui-select')

            -- keymap
            local keymap = require('utils.keymap')

            local get_visual_selection = require('custom.get-visual-selection')

            local tb = require('telescope.builtin')

            local tb_opt = {
                fname_width = 0.5,
                trim_text = false,
                show_line = false,
                include_current_line = true,
            }

            -- Core
            keymap.normal('<leader>m', ':Telescope<cr>')
            keymap.normal(',.', ':Telescope find_files hidden=false<cr>')
            keymap.normal('<leader>,', ':Telescope find_files hidden=true<cr>')
            keymap.normal(
                '<leader>.',
                ':lua require("telescope").extensions.file_browser.file_browser({hidden = true, path = "%:p:h", grouped = false, hide_parent_dir = false, select_buffer = true, respect_gitignore = true })<cr>'
            )

            keymap.normal('<leader>fb', ':Telescope buffers<cr>')
            keymap.normal('<leader>fg', ':Telescope live_grep<cr>')
            keymap.normal('<leader>fr', ':Telescope resume<cr>')

            local open_quick_fix_window_in_telescope = function()
                vim.cmd('cclose')
                tb.quickfix({ fname = 0.5, trim_text = false, show_line = false })
            end
            keymap.normal('fq', open_quick_fix_window_in_telescope, { desc = 'Open QuickFix in Telescope' })

            keymap.normal('<leader>fQ', ':Telescope quickfixhistory<cr>')
            keymap.normal('<leader>fp', ':Telescope project<cr>')
            keymap.normal('<leader>fo', ':Telescope oldfiles cwd_only=true<cr>')
            keymap.normal('<leader>fh', ':Telescope help_tags<cr>')
            keymap.normal('<leader>fm', ':Telescope keymaps<cr>')
            keymap.normal('<leader>f;', ':Telescope commands<cr>')

            -- Custom goto commands
            keymap.normal('<leader>ve', ':GotoVimFind<cr>')
            keymap.normal('<leader>fvf', ':GotoVimFind<cr>')
            keymap.normal('<leader>fvb', ':GotoVimBrowse<cr>')
            keymap.normal('<leader>fvs', ':GotoVimGit<cr>')
            keymap.normal('<leader>fvg', ':GotoVimGrep<cr>')

            keymap.normal('<leader>fzf', ':GotoZshFind<cr>')
            keymap.normal('<leader>fzb', ':GotoZshBrowse<cr>')
            keymap.normal('<leader>fzs', ':GotoZshGit<cr>')
            keymap.normal('<leader>fzg', ':GotoZshGrep<cr>')

            keymap.normal('<leader>fdf', ':GotoDotFind<cr>')
            keymap.normal('<leader>fdb', ':GotoDotBrowse<cr>')
            keymap.normal('<leader>fds', ':GotoDotGit<cr>')
            keymap.normal('<leader>fdg', ':GotoDotGrep<cr>')

            keymap.normal('<leader>fcf', ':GotoCodeFind<cr>')
            keymap.normal('<leader>fcb', ':GotoCodeBrowse<cr>')
            keymap.normal('<leader>fcs', ':GotoCodeGit<cr>')
            keymap.normal('<leader>fcg', ':GotoCodeGrep<cr>')

            keymap.visual('<leader>fg', function()
                tb.live_grep({ default_text = get_visual_selection() })
            end, { noremap = true, silent = true })
        end,
    },
}