local map = require('utils.map')

-- WINDOWS AND TABS --
----------------------
-- Zoom / Fullscreen
map.normal('<C-w>z', ':ZoomWinTabToggle<CR>')
map.normal('<C-w><C-z>', ':ZoomWinTabToggle<CR>')

map.normal('tt', ':tab split<CR>')

-- split navigations
map.normal('<A-h>', '<C-w><C-h>')
map.normal('<A-j>', '<C-w><C-j>')
map.normal('<A-k>', '<C-w><C-k>')
map.normal('<A-l>', '<C-w><C-l>')

-- resize
map.normal('<Up>', ':resize +5<cr>')
map.normal('<Down>', ':resize -5<cr>')

map.normal('<Left>', ':vertical resize -5<cr>')
map.normal('<Right>', ':vertical resize +5<cr>')
