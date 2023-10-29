local keymap = require("utils.keymap")
keymap.normal("<leader>gg", ":LazyGitCurrentFile<cr>")
keymap.normal("<leader>GG", ":LazyGitFilterCurrentFile<cr>")
