require('utils.globals')

require('keymaps.general') -- always first

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',     -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- -- Make sure to set `mapleader` before lazy so your mappings are correct.
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

require('lazy').setup('plug/all-spec',{
  change_detection = {
    enabled = false,
  } ,
  install = {
    colorscheme = { "gruvbox" }
  }

})

require('custom')

-- require('theme')
require('lsp')
require('config')

require('keymaps')
require('autocmd')
