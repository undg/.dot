require('utils.globals')

-- -- Make sure to set `mapleader` before lazy so your mappings are correct.
require('keymap.general') -- always first


-- install Lazy if necessary.
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

require('lazy').setup('plugin/all-spec',{
  change_detection = {
    enabled = false,
  } ,
  install = {
    colorscheme = { "gruvbox" }
  }

})

require('custom')

require('lsp')
require('config')

require('keymap')
require('autocmd')
