require('utils.globals')

local ok_packer, _ = pcall(require, 'packer')

if ok_packer then
    require('plugins')
end

if PACKER_BOOTSTRAPING then
    return
end

require('custom')

require('theme')
require('lsp')
require('config')

require('keymaps')
require('autocmd')
