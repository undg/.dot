local map = require('utils.map')

map.normal('<c-_>', ':lua R("custom.indent.indent").toggle()<cr>', {silent = false})

