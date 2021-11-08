-- source a Vimscript file
-- vim.cmd('source ~/.vim/init.vim')
require('plugins')

require('settings')
require('keymaps')
require('colors')

require('plugins/treesitter')
require('plugins/vim-gitgutter')
require('plugins/nerdtree')
require('plugins/fzf-lua')
require('plugins/nvim-web-devicons')
require('plugins/QFEnter')

-- require('plugins/lspsaga')
require('plugins/lsp-installer')
