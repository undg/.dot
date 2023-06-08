local map = require('utils.map')

-- Select/Goto
map.normal('<leader>bp', ':BufferLineCyclePrev<cr>')
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
map.normal('<C-j>', ':BufferLineMovePrev<cr>')
map.normal('<C-k>', ':BufferLineMoveNext<cr>')
map.normal('<C-h>', ':BufferLineCyclePrev<cr>')
map.normal('<C-l>', ':BufferLineCycleNext<cr>')

-- Close
local CMD_CLOSE_GO_NEXT = ':BufferLineCycleNext<CR>:BufferLineCyclePrev<CR>:Bdelete<cr>'
local CMD_CLOSE_GO_PREV = ':Bdelete<cr>'
map.normal('<leader>qq', CMD_CLOSE_GO_NEXT)

map.normal('<C-Q>', CMD_CLOSE_GO_PREV)
map.normal('<leader>bcc', CMD_CLOSE_GO_PREV)
map.normal('<leader>bch', ':BufferLineCloseLeft<CR>')
map.normal('<leader>bcl', ':BufferLineCloseRight<CR>')

map.normal(';q', ':q<cr>')
