local keymap = require('utils.keymap')

keymap.normal(']t', ':lua require("trouble").next({skip_groups = true, jump = true})<cr>')
keymap.normal('[t', ':lua require("trouble").previous({skip_groups = true, jump = true})<cr>')


