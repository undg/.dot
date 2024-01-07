local keymap = require('utils.keymap')

-- WINDOWS AND TABS --
----------------------
-- Zoom / Fullscreen
keymap.normal('tt', ':tab split<CR>')

-- split navigations is done by tmux-navigator plugin
-- keymap.normal('<A-h>', '<C-w><C-h>')
-- keymap.normal('<A-j>', '<C-w><C-j>')
-- keymap.normal('<A-k>', '<C-w><C-k>')
-- keymap.normal('<A-l>', '<C-w><C-l>')

-- resize
keymap.normal('<Up>', ':resize +5<cr>')
keymap.normal('<Down>', ':resize -5<cr>')

keymap.normal('<Left>', ':vertical resize -5<cr>')
keymap.normal('<Right>', ':vertical resize +5<cr>')
