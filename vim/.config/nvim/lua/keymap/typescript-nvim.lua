Keymap.normal('<leader>to', ':lua require("typescript").actions.organizeImports({sync=true})<cr>')
Keymap.normal('<leader>tp', ':lua require("typescript").actions.removeUnused({sync = true})<cr>')
Keymap.normal('<leader>ti', ':lua require("typescript").actions.addMissingImports({sync = true})<cr>')

-- Keymap.normal('<leader>to', ':TypescriptOrganizeImports<cr>')
-- Keymap.normal('<leader>tp', ':TypescriptRemoveUnused<cr>')
-- Keymap.normal('<leader>ti', ':TypescriptAddMissingImports<cr>')
