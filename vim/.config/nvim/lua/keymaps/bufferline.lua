local map = require("utils.map")


-- Select/Goto
map.normal("H", ":BufferLineCyclePrev<cr>")
map.normal("<leader>bp", ":BufferLineCyclePrev<cr>")

map.normal("L", ":BufferLineCycleNext<cr>")
map.normal("<leader>bn", ":BufferLineCycleNext<cr>")

map.normal("<leader>bj", ":BufferLineGoToBuffer 1<cr>")
map.normal("<leader>bk", ":BufferLineGoToBuffer 2<cr>")
map.normal("<leader>bl", ":BufferLineGoToBuffer 3<cr>")
map.normal("<leader>b;", ":BufferLineGoToBuffer 4<cr>")
map.normal("<leader>b'", ":BufferLineGoToBuffer 5<cr>")
map.normal("<leader>b$", ":BufferLineGoToBuffer -1<cr>")


-- Pin
map.normal("<leader>bb", ":BufferLineTogglePin<cr>")


-- Move
map.normal("<A-h>", ":BufferLineMovePrev<cr>")
map.normal("<A-l>", ":BufferLineMoveNext<cr>")

