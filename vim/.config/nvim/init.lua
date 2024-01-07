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
