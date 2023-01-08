require('utils.globals')


local packer_bootstrap = PACKER_BOOTSTRAP

if not packer_bootstrap then
    require('plugins')
    require('custom')

    require('theme')
    require('lsp')
    require('config')


    require('keymaps')
    require('autocmd')
end
