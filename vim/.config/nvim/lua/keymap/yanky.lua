local keymap = require('utils.keymap')

-- override default keybindings with wrappers around them.
keymap.normal('p', '<Plug>(YankyPutAfter)')
keymap.normal('P', '<Plug>(YankyPutBefore)')
keymap.xisual('p', '<Plug>(YankyPutAfter)')
keymap.xisual('P', '<Plug>(YankyPutBefore)')

keymap.normal('<leader>n', '<Plug>(YankyCycleForward)', { noremap = false })
keymap.normal('<leader>N', '<Plug>(YankyCycleBackward)', { noremap = false })
keymap.normal('<leader>h', '<cmd>Telescope yank_history<cr>', { noremap = false })
