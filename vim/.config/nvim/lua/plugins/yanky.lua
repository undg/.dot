local map = require("utils/map")

require("yanky").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    ring = {
        history_length = 16,
        storage = "shada",
        sync_with_numbered_registers = true,
    },
    picker = {
        select = {
            -- action = nil, -- nil to use default put action
        },
        telescope = {
            -- mappings = nil, -- nil to use default mappings
        },
    },
    system_clipboard = {
        sync_with_ring = true,
    },
    highlight = {
        on_put = true,
        on_yank = true,
        timer = 100,
    },
    preserve_cursor_position = {
        enabled = true,
    }
})

-- override default keybindings with wrappers around them.
map.normal("p", "<Plug>(YankyPutAfter)")
map.normal("P", "<Plug>(YankyPutBefore)")
map.xisual("p", "<Plug>(YankyPutAfter)")
map.xisual("P", "<Plug>(YankyPutBefore)")
map.normal("gp", "<Plug>(YankyGPutAfter)")
map.normal("gP", "<Plug>(YankyGPutBefore)")
map.xisual("gp", "<Plug>(YankyGPutAfter)")
map.xisual("gP", "<Plug>(YankyGPutBefore)")

-- key maps
map.normal("<leader>n", "<Plug>(YankyCycleForward)", {noremap = false})
map.normal("<leader>N", "<Plug>(YankyCycleBackward)", {noremap = false})
map.normal("<leader>h", "<cmd>Telescope yank_history<cr>", {noremap = false})

-- telescope integration
require("telescope").load_extension("yank_history")
