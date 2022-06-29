local map = require('../utils/map')

-- disable default mappings h:gitgutter-mappings
vim.g.gitgutter_map_keys = 0

-- To change the hunk-jumping maps (defaults shown):
map.normal('[{', ':GitGutterPrevHunk<CR>zz')
map.normal(']}', ':GitGutterNextHunk<CR>zz')

map.normal('g(', ':GitGutterPrevHunk<CR>zz')
map.normal('g)', ':GitGutterNextHunk<CR>zz')
-- Legacy fallback
map.normal('[g', ':GitGutterPrevHunk<CR>zz')
map.normal(']g', ':GitGutterNextHunk<CR>zz')

-- To change staging/undoing/previewing hunk:
map.normal('gs', ':GitGutterStageHunk<CR>')
map.normal('gu', ':GitGutterUndoHunk<CR>')
map.normal('gp', ':GitGutterPreviewHunk<CR>')

