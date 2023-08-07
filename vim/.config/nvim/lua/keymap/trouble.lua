local map = require('utils.map')

map.normal(']t', ':lua require("trouble").next({skip_groups = true, jump = true})<cr>')
map.normal('[t', ':lua require("trouble").previous({skip_groups = true, jump = true})<cr>')


