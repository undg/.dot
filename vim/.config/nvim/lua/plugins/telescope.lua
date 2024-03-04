return {
    {
        'nvim-telescope/telescope.nvim',                                    -- https://github.com/nvim-telescope/telescope.nvim
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
            'nvim-telescope/telescope-ui-select.nvim',                      -- https://github.com/nvim-telescope/telescope-ui-select.nvim
        },
        config = function()
            local ok_telescope, telescope = pcall(require, 'telescope')
            local ok_actions, actions = pcall(require, 'telescope.actions')

            if not ok_telescope or not ok_actions then
                print('plugins/telescope/goto: missing requirements')
                return
            end

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
                    smart_open = {
                        show_scores = true,
                        ignore_patterns = { '*.git/*', '*/tmp/*' },
                        match_algorithm = 'fzf',
                        disable_devicons = false,
                        open_buffer_indicators = { previous = '👀', others = '🙈' },
                    },
                },
            })

            -- load_extension's, somewhere after setup function:
            telescope.load_extension('fzf')
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

            keymap.normal('<leader>m', ':Telescope<cr>')
            -- keymap.normal(',.', ':Telescope find_files hidden=false<cr>')
            keymap.normal(',.', ':Telescope smart_open<cr>')
            -- keymap.normal('<leader>,', ':Telescope find_files hidden=true<cr>')
            keymap.normal('<leader>,', ':Telescope smart_open<cr>')
            -- -- @TODO (undg) 2024-03-04: use new plugin for it
            -- keymap.normal('<leader>.', ':')

            keymap.normal('<leader>fb', ':Telescope buffers<cr>')
            keymap.normal('<leader>fg', ':Telescope live_grep<cr>')
            -- -- @TODO (undg) 2024-03-04: use new plugin for it
            keymap.normal('<leader>fG', ':')
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
            keymap.normal('<leader>fc', ':Telescope commands<cr>')

            keymap.visual('<leader>fg', function()
                tb.live_grep({ default_text = get_visual_selection() })
            end, { noremap = true, silent = true })
        end,
    },
}
