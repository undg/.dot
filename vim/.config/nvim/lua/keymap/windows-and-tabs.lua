-- WINDOWS AND TABS --
----------------------
-- Zoom / Fullscreen
Keymap.normal('tt', ':tab split<CR>')

-- split navigations is done by tmux-navigator plugin
-- keymap.normal('<A-h>', '<C-w><C-h>')
-- keymap.normal('<A-j>', '<C-w><C-j>')
-- keymap.normal('<A-k>', '<C-w><C-k>')
-- keymap.normal('<A-l>', '<C-w><C-l>')

-- resize
Keymap.normal('<Up>', ':resize +5<cr>')
Keymap.normal('<Down>', ':resize -5<cr>')

Keymap.normal('<Left>', ':vertical resize -5<cr>')
Keymap.normal('<Right>', ':vertical resize +5<cr>')
