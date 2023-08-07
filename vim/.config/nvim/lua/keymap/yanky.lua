local map = require('utils.map')

-- override default keybindings with wrappers around them.
map.normal('p', '<Plug>(YankyPutAfter)')
map.normal('P', '<Plug>(YankyPutBefore)')
map.xisual('p', '<Plug>(YankyPutAfter)')
map.xisual('P', '<Plug>(YankyPutBefore)')

map.normal('<leader>n', '<Plug>(YankyCycleForward)', { noremap = false })
map.normal('<leader>N', '<Plug>(YankyCycleBackward)', { noremap = false })
map.normal('<leader>h', '<cmd>Telescope yank_history<cr>', { noremap = false })
