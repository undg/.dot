local map = require('utils.map')

map.normal('<leader>to', ':lua require("typescript").actions.organizeImports({sync=true})<cr>')
map.normal('<leader>tp', ':lua require("typescript").actions.removeUnused({sync = true})<cr>')
map.normal('<leader>ti', ':lua require("typescript").actions.addMissingImports({sync = true})<cr>')

-- map.normal('<leader>to', ':TypescriptOrganizeImports<cr>')
-- map.normal('<leader>tp', ':TypescriptRemoveUnused<cr>')
-- map.normal('<leader>ti', ':TypescriptAddMissingImports<cr>')

