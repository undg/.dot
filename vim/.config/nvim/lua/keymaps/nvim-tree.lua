local map = require('utils.map')

map.normal('<F2>', ':NvimTreeFindFileToggle<CR>')
map.normal('<leader>2', ':NvimTreeFindFileToggle<CR>')

-- @TODO (undg) 2022-12-27: create wrapper for toggling focus between windows.
map.normal('<F3>', ':NvimTreeFindFile<cr>')
map.normal('<leader>3', ':NvimTreeFindFile<cr>')

map.normal('<F4>', ':NvimTreeClose<cr>')
map.normal('<leader>4', ':NvimTreeClose<cr>')

map.normal('<leader>ff', ':NvimTreeFindFileToggle<cr>')
-- map.normal("<leader>fc", ":NvimTreeClose<cr>")
