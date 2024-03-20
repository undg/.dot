require('utils.globals')

-- Make sure to set `mapleader` before lazy so your mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


require('plugins')
require('start-lazy')

require('custom')

require('lsp')

require('config')

require('keymap')

require('autocmd')

-- @TODO (undg) 2024-03-20: Check it once a while and try to delete fix.
require('custom.hover-fix')
