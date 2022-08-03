local map = require("../utils/map")

map.normal(
    "<leader>vw",
    ":lua ReloadConfig()<CR>" .. ":source " .. vim.env.MYVIMRC .. '<cr>:echom "Source MYVIMRC"<CR>'
)
