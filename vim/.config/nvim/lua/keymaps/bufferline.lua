local map = require("utils.map")


-- Select/Goto
map.normal("H", ":BufferLineCyclePrev<cr>")
map.normal("<leader>bp", ":BufferLineCyclePrev<cr>")

map.normal("L", ":BufferLineCycleNext<cr>")
map.normal("<leader>bn", ":BufferLineCycleNext<cr>")

map.normal("<leader>j", ":BufferLineGoToBuffer 1<cr>")
map.normal("<leader>k", ":BufferLineGoToBuffer 2<cr>")
map.normal("<leader>l", ":BufferLineGoToBuffer 3<cr>")
map.normal("<leader>;", ":BufferLineGoToBuffer 4<cr>")
map.normal("<leader>'", ":BufferLineGoToBuffer 5<cr>")
map.normal("<leader>$", ":BufferLineGoToBuffer -1<cr>")


-- Pin
map.normal("<leader>bb", ":BufferLineTogglePin<cr>")


-- Move
map.normal("<A-h>", ":BufferLineMovePrev<cr>")
map.normal("<A-l>", ":BufferLineMoveNext<cr>")

