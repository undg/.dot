require('utils.globals')

-- -- Make sure to set `mapleader` before lazy so your mappings are correct.
require('keymap.general')

require('plugins')
require('start-lazy')

require('custom')

require('lsp')

require('config')

-- @TODO (undg) 2024-01-07: move them to plugins
require('keymap')

require('autocmd')
