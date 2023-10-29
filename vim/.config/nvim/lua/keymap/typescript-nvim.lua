local keymap = require('utils.keymap')

keymap.normal('<leader>to', ':lua require("typescript").actions.organizeImports({sync=true})<cr>')
keymap.normal('<leader>tp', ':lua require("typescript").actions.removeUnused({sync = true})<cr>')
keymap.normal('<leader>ti', ':lua require("typescript").actions.addMissingImports({sync = true})<cr>')

-- keymap.normal('<leader>to', ':TypescriptOrganizeImports<cr>')
-- keymap.normal('<leader>tp', ':TypescriptRemoveUnused<cr>')
-- keymap.normal('<leader>ti', ':TypescriptAddMissingImports<cr>')

