local map = require("utils/map")

require("yanky").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    ring = {
        history_length = 10,
        storage = "shada",
        sync_with_numbered_registers = true,
    },
    system_clipboard = {
        sync_with_ring = true,
    },
    -- picker = {
    --     select = {
    --         -- action = nil, -- nil to use default put action
    --     },
    --     telescope = {
    --         -- mappings = nil, -- nil to use default mappings
    --     },
    -- },
})

map.normal("p", "<Plug>(YankyPutAfter)")
map.normal("P", "<Plug>(YankyPutBefore)")
map.xisual("p", "<Plug>(YankyPutAfter)")
map.xisual("P", "<Plug>(YankyPutBefore)")
map.normal("gp", "<Plug>(YankyGPutAfter)")
map.normal("gP", "<Plug>(YankyGPutBefore)")
map.xisual("gp", "<Plug>(YankyGPutAfter)")
map.xisual("gP", "<Plug>(YankyGPutBefore)")

map.normal("<leader>n", "<Plug>(YankyCycleForward)", {noremap = false})
map.normal("<leader>N", "<Plug>(YankyCycleBackward)", {noremap = false})

