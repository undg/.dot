local map = require('utils.map')

require('telescope').setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
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

map.normal('<leader>ff', ':Telescope find_files<cr>')
map.normal('<leader>.', ':Telescope find_files<cr>')

map.normal('<leader>ft', ':Telescope<cr>')
map.normal('<leader>m', ':Telescope<cr>')

map.normal('<leader>fb', ':Telescope buffers<cr>')
map.normal('<leader>b', ':Telescope buffers<cr>')

map.normal('<leader>fg', ':Telescope live_grep<cr>')
map.normal('<leader>fs', ':Telescope git_status<cr>')
map.normal('<leader>sf', ':Telescope git_status<cr>')
-- map.normal('<leader>', ':Telescope<cr>')
-- map.normal('<leader>', ':Telescope<cr>')
