local keymap = require('utils.keymap')

-- Select/Goto
keymap.normal('<leader>bp', ':BufferLineCyclePrev<cr>')
keymap.normal('<leader>bn', ':BufferLineCycleNext<cr>')

keymap.normal('<leader>j', ':BufferLineGoToBuffer 1<cr>')
keymap.normal('<leader>k', ':BufferLineGoToBuffer 2<cr>')
keymap.normal('<leader>l', ':BufferLineGoToBuffer 3<cr>')
keymap.normal('<leader>;', ':BufferLineGoToBuffer 4<cr>')
keymap.normal("<leader>'", ':BufferLineGoToBuffer 5<cr>')
keymap.normal('<leader>$', ':BufferLineGoToBuffer -1<cr>')

-- Pin
keymap.normal('<leader>bb', ':BufferLineTogglePin<cr>')

-- Move
keymap.normal('<C-j>', ':BufferLineMovePrev<cr>')
keymap.normal('<C-k>', ':BufferLineMoveNext<cr>')
keymap.normal('<C-h>', ':BufferLineCyclePrev<cr>')
keymap.normal('<C-l>', ':BufferLineCycleNext<cr>')

-- Close
local CMD_CLOSE_GO_NEXT = ':BufferLineCycleNext<CR>:BufferLineCyclePrev<CR>:Bdelete<cr>'
local CMD_CLOSE_GO_PREV = ':Bdelete<cr>'
keymap.normal('<leader>qq', CMD_CLOSE_GO_NEXT)

keymap.normal('<C-Q>', CMD_CLOSE_GO_PREV)
keymap.normal('<leader>bcc', CMD_CLOSE_GO_PREV)
keymap.normal('<leader>bch', ':BufferLineCloseLeft<CR>')
keymap.normal('<leader>bcl', ':BufferLineCloseRight<CR>')

keymap.normal(';q', ':q<cr>')
