local actions = require("telescope.actions")
local fb_actions = require("telescope").extensions.file_browser.actions
-- local trouble = require("trouble.providers.telescope")

require("telescope").setup({
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        layout_strategy = "vertical",
        layout_config = { height = 0.9, width = 0.9 },
        mappings = {
            i = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-j>"] = actions.move_selection_next,
                ["<Down>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Up>"] = actions.move_selection_previous,

                ["<CR>"] = actions.select_default,
                ["<C-l>"] = actions.select_default,

                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,

                ["<C-u>"] = nil,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<C-d>"] = nil,
                ["<PageDown>"] = actions.results_scrolling_down,

                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<C-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C- >"] = actions.toggle_selection,

                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                -- ["<C-l>"] = actions.complete_tag,
                ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                ["<C-w>"] = { "<c-s-w>", type = "command" },

                ["<esc>"] = actions.close,
                ["<C-c>"] = actions.close,
                ["<C-m>"] = nil,
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
        -- the loading is important
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        file_browser = {
            -- theme = "ivy",
            layout_strategy = "vertical",
            layout_config = { height = 0.9, width = 0.9 },
            mappings = {
                i = {
                    ["<C-i>"] = fb_actions.toggle_hidden,
                    ["<C-h>"] = fb_actions.goto_parent_dir,
                    ["<C-c>"] = fb_actions.create,
                    ["<C-n>"] = fb_actions.rename,
                    ["<C-d>"] = fb_actions.remove,
                    ["<C-a>"] = fb_actions.select_all,
                },
            },
        },
    },
})
-- load_extension's, somewhere after setup function:
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("harpoon")

require("plugins.telescope.goto_commands")
