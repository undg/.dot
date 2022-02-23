require('utils.globals')

require('config')

require('plugins')
-- require('plugins.vim-gitgutter')
-- require('plugins.nerdtree') -- @TODO ♻ port ♻
-- require('plugins.QFEnter')
-- require('plugins.vim-yoink')

require('custom.statusline')
require('custom.tabline')
require('custom.search-selected')
require('custom.auto-relative-numbers')
require('custom.indent')
require('custom.json2ts')
require('custom.reload-config')
require('custom.update')
-- require('custom.auto-highlight-toggle') -- @TODO ♻ port ♻

require('keymaps')
require('keymaps.lsp')
require('keymaps.spell')
require('keymaps.edit-myvimrc')

