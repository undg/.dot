require('utils.globals')


local packer_bootstrap = PACKER_BOOTSTRAP
require('plugins')

if not packer_bootstrap then
    require('custom')

    require('theme')
    require('lsp')
    require('config')


    require('keymaps')
    require('autocmd')
end
