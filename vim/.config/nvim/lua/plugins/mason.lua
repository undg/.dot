local border_ok, border = pcall(require, 'utils.border')
local not_ok = not border_ok and 'utils.border' --
    or false

if not_ok then
    vim.notify('pligins/mason.lua: missing required ', not_ok)
end

return {
    'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
    dependencies = {
        -- integration with lspconfig
        'williamboman/mason-lspconfig.nvim', -- https://github.com/williamboman/mason-lspconfig.nvim

        -- auto install predefined packages
        'WhoIsSethDaniel/mason-tool-installer.nvim', -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    },
    config = function()
        require('mason').setup({
            ui = {
                border = border,
            },
        })
    end,
}
