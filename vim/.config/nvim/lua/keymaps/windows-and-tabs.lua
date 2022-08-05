local map = require("utils.map")

-- WINDOWS AND TABS --
----------------------
--
map.normal("<A-H>", "<C-w>H")
map.normal("<A-J>", "<C-w>J")
map.normal("<A-K>", "<C-w>K")
map.normal("<A-L>", "<C-w>L")


-- Zoom / Fullscreen
map.normal("<C-w>z", ":ZoomWinTabToggle<CR>")
map.normal("<C-w><C-z>", ":ZoomWinTabToggle<CR>")

map.normal("tt", ":tabnew %<CR>")
map.normal("<C-w>t", ":tabnew %<CR>")
map.normal("<C-w><C-t>", ":tabnew %<CR>")

-- split navigations
map.normal("<C-h>", "<C-w><C-h>")
map.normal("<C-j>", "<C-w><C-j>")
map.normal("<C-k>", "<C-w><C-k>")
map.normal("<C-l>", "<C-w><C-l>")

-- tab change
-- gt <--
map.normal("<A-h>", "gT")
map.normal("<A-j>", "gT")
-- gT -->
map.normal("<A-k>", "gt")
map.normal("<A-l>", "gt")


