require('utils.globals')

local ok_packer, _ = pcall(require, 'packer')
local bootstraping = PACKER_BOOTSTRAPING

if ok_packer then
    require('plugins')
end

if bootstraping then
    return
end

require('custom')

require('theme')
require('lsp')
require('config')

require('keymaps')
require('autocmd')
