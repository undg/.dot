local map = require("utils.map")

map.normal("<leader>tt", ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
map.normal("<leader>tr", ":Telescope harpoon marks<cr>")
map.normal("<leader>ta", ":lua require('harpoon.mark').add_file()<cr>")
map.normal("<leader>tj", ":lua require('harpoon.ui').nav_next()<cr>")
map.normal("<leader>tk", ":lua require('harpoon.ui').nav_prev()<cr>")

map.normal("<leader>j", ":lua require('harpoon.ui').nav_file(1)<cr>")
map.normal("<leader>k", ":lua require('harpoon.ui').nav_file(2)<cr>")
map.normal("<leader>l", ":lua require('harpoon.ui').nav_file(3)<cr>")
map.normal("<leader>;", ":lua require('harpoon.ui').nav_file(4)<cr>")
map.normal("<leader>'", ":lua require('harpoon.ui').nav_file(5)<cr>")
