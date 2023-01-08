require('utils.globals')
require('plugins')

require('custom')
local packer_bootstrap = PACKER_BOOTSTRAP

if packer_bootstrap then
    require('theme')
    require('lsp')
    require('config')

    require('keymaps')
    require('autocmd')
end
