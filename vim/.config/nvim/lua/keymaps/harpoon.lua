local map = require("utils.map")

map.normal("<leader>tt", ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
map.normal("<leader>tr", ":Telescope harpoon marks<cr>")
map.normal("<leader>ta", ":lua require('harpoon.mark').add_file()<cr>")
map.normal("<leader>tj", ":lua require('harpoon.ui').nav_next()<cr>")
map.normal("<leader>tk", ":lua require('harpoon.ui').nav_prev()<cr>")

map.normal("<leader>fj", ":lua require('harpoon.ui').nav_file(1)<cr>")
map.normal("<leader>fk", ":lua require('harpoon.ui').nav_file(2)<cr>")
map.normal("<leader>fl", ":lua require('harpoon.ui').nav_file(3)<cr>")
map.normal("<leader>f;", ":lua require('harpoon.ui').nav_file(4)<cr>")
map.normal("<leader>f'", ":lua require('harpoon.ui').nav_file(5)<cr>")
