local map = require('../utils/map')

-- To change the hunk-jumping maps (defaults shown):
map.normal('g[', '<Plug>(GitGutterPrevHunk)zz')
map.normal('g]', '<Plug>(GitGutterNextHunk)zz')

-- To change the hunk-staging/undoing/previewing maps (defaults shown):
map.normal('gs', '<Plug>(GitGutterStageHunk)')
map.normal('gu', '<Plug>(GitGutterUndoHunk)')
map.normal('gp', '<Plug>(GitGutterPreviewHunk)')

