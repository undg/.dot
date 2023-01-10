local map = require('utils.map')

-- Select/Goto
map.normal('H', ':BufferLineCyclePrev<cr>')
map.normal('<leader>bp', ':BufferLineCyclePrev<cr>')

map.normal('L', ':BufferLineCycleNext<cr>')
map.normal('<leader>bn', ':BufferLineCycleNext<cr>')

map.normal('<leader>j', ':BufferLineGoToBuffer 1<cr>')
map.normal('<leader>k', ':BufferLineGoToBuffer 2<cr>')
map.normal('<leader>l', ':BufferLineGoToBuffer 3<cr>')
map.normal('<leader>;', ':BufferLineGoToBuffer 4<cr>')
map.normal("<leader>'", ':BufferLineGoToBuffer 5<cr>')
map.normal('<leader>$', ':BufferLineGoToBuffer -1<cr>')

-- Pin
map.normal('<leader>bb', ':BufferLineTogglePin<cr>')

-- Move
map.normal('<A-h>', ':BufferLineMovePrev<cr>')
map.normal('<A-l>', ':BufferLineMoveNext<cr>')

-- Close
local CMD_CLOSE = ':BufferLineCycleNext<CR>:BufferLineCyclePrev<CR>:Bdelete<cr>:echom "buffer deleted"<cr>'
map.normal('<leader>qh', ':BufferLineCloseLeft<CR>:echom "buffer deleted"<cr>')
map.normal('<leader>qj', CMD_CLOSE)
map.normal('<leader>qk', CMD_CLOSE)
map.normal('<leader>qq', CMD_CLOSE)
map.normal('<leader>ql', ':BufferLineCloseRight<cr>:echom "buffer deleted"<cr>')

map.normal(';q', CMD_CLOSE)
map.normal('<C-Q><C-Q>', CMD_CLOSE)
