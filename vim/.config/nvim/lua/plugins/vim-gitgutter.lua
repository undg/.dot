local map = require('../utils/map')

-- To change the hunk-jumping maps (defaults shown):
map.normal('[g', ':GitGutterPrevHunk<CR>zz')
map.normal(']g', ':GitGutterNextHunk<CR>zz')

-- To change the hunk-staging/undoing/previewing maps (defaults shown):
map.normal('gs', ':GitGutterStageHunk<CR>')
map.normal('gu', ':GitGutterUndoHunk<CR>')
map.normal('gp', ':GitGutterPreviewHunk<CR>')

