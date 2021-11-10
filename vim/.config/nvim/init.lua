require('utils.globals')
local map = require('utils.map')

require('config')
require('theme')

require('keymaps')
require('keymaps.lsp')
require('keymaps.spell')

require('plugins')
require('plugins.packer-startup')
require('plugins.treesitter')
require('plugins.vim-gitgutter')
require('plugins.nerdtree') -- @TODO ♻ port ♻
require('plugins.nvim-web-devicons')
require('plugins.QFEnter')
require('plugins.lsp-installer')
require('plugins.nvim-cmp')
-- require('plugins/nvim-miniyank') -- @TODO 🐛 debug 🐛

require('custom.statusline')
require('custom.tabline')
require('custom.search-selected')
require('custom.auto-relative-numbers')
require('custom.indent') -- @TODO 🚮 clean it 🚮
map.normal('<c-_>', ':lua R("custom.indent").toggle()<cr>', {silent = false})
-- require('custom.auto-highlight-toggle') -- @TODO ♻ port ♻

