local keymap = require("utils.keymap")

keymap.normal("<leader>tt", ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
keymap.normal("<leader>tr", ":Telescope harpoon marks<cr>")
keymap.normal("<leader>ta", ":lua require('harpoon.mark').add_file()<cr>")
keymap.normal("<leader>tj", ":lua require('harpoon.ui').nav_next()<cr>")
keymap.normal("<leader>tk", ":lua require('harpoon.ui').nav_prev()<cr>")

keymap.normal("<leader>fj", ":lua require('harpoon.ui').nav_file(1)<cr>")
keymap.normal("<leader>fk", ":lua require('harpoon.ui').nav_file(2)<cr>")
keymap.normal("<leader>fl", ":lua require('harpoon.ui').nav_file(3)<cr>")
keymap.normal("<leader>f;", ":lua require('harpoon.ui').nav_file(4)<cr>")
keymap.normal("<leader>f'", ":lua require('harpoon.ui').nav_file(5)<cr>")
