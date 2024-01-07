-- require('keymap.general') -- always first

require('keymap.lsp')

require('keymap.spell')
require('keymap.windows-and-tabs')

require('keymap.typescript-nvim')
require('keymap.bufferline')
require('keymap.tabular')
require('keymap.fugitive')

local keymap = require('utils.keymap')
-- move selection up and down
keymap.xisual('<C-k>', ':m -2<CR>gv=gv')
keymap.xisual('<C-j>', ":m '>+<CR>gv=gv")
keymap.visual('<C-k>', ':m -2<CR>gv=gv')
keymap.visual('<C-j>', ":m '>+<CR>gv=gv")
