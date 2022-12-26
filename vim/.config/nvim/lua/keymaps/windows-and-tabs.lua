local map = require("utils.map")

-- WINDOWS AND TABS --
----------------------
-- Zoom / Fullscreen
map.normal("<C-w>z", ":ZoomWinTabToggle<CR>")
map.normal("<C-w><C-z>", ":ZoomWinTabToggle<CR>")

map.normal("tt", ":tab split<CR>")
map.normal("<C-w>t", ":tabnew %<CR>")
map.normal("<C-w><C-t>", ":tabnew %<CR>")

-- split navigations
map.normal("<C-h>", "<C-w><C-h>")
map.normal("<C-j>", "<C-w><C-j>")
map.normal("<C-k>", "<C-w><C-k>")
map.normal("<C-l>", "<C-w><C-l>")

-- resize
map.normal("<Up>", ":resize +5<cr>")
map.normal("<Down>", ":resize -5<cr>")

map.normal("<Left>", ":vertical resize -5<cr>")
map.normal("<Right>", ":vertical resize +5<cr>")

-- -- tab change
-- -- gt <--
-- map.normal("<A-h>", "gT")
-- map.normal("<A-j>", "gT")
-- -- gT -->
--map.normal("<A-k>", "gt")
-- map.normal("<A-l>", "gt")
