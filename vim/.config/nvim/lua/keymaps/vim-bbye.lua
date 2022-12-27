local map = require('utils.map')

map.normal('<leader>q', ':Bdelete<cr>:echom "buffer deleted"<cr>')
map.normal('<C-Q><C-Q>', ':Bdelete<cr>:echom "buffer deleted"<cr>')
map.normal('QQ', ':Bdelete<cr>:echom "buffer deleted"<cr>')
