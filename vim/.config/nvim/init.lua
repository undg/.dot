require('settings')
require('theme')

require('keymaps')
require('keymaps/lsp')

require('plugins')
require('plugins/packer-startup')
require('plugins/treesitter')
require('plugins/vim-gitgutter')
require('plugins/nerdtree')
require('plugins/nvim-web-devicons')
require('plugins/QFEnter')
require('plugins/lsp-installer')
require('plugins/nvim-cmp')
-- @TODO 🐛 debug 🐛
-- require('plugins/nvim-miniyank')



-- source a Vimscript file
-- LEGACY vim compatibility layer
-- vim.cmd('source ~/.vim/init.vim')

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer-startup.lua source <afile> | PackerCompile
  augroup end
]])
