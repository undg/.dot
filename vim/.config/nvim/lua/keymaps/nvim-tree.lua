local map = require('utils.map')

map.normal('<F2>', ':NvimTreeFindFileToggle<cr>')
map.normal('<F3>', ':NvimTreeFindFile<cr>')
map.normal('<F4>', ':NvimTreeClose<cr>')

map.normal('<leader>ff', ':NvimTreeFindFile<cr>')
map.normal('<leader>fc', ':NvimTreeClose<cr>')
