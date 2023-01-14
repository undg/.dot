local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_ok or not mason_lspconfig_ok then
    print('lsp/init.lua: require failed')
end

-- Lsp server name is same as file name with config.
-- [key: type] = {
--      [key: lsp server name] = 'mason pkg name'
-- }
-- @module lsp2mason
local lsp2mason = {
    cfg_file = {
        denols = 'deno',
        jsonls = 'json-lsp',
        tsserver = 'typescript-language-server',
        yamlls = 'yaml-language-server',
        sumenko_lua = 'lua-language-server',
    },
    cfg_no = {
        cssls = 'cssls',
        html = 'html',
        prosemd_lsp = 'prosemd-lsp',
        clangd = 'clangd',
        pyright = 'pyright',
    },
    formatter = {
        stylua = 'stylua'
    },
}

local tc = TableConcat
local ensure_installed = tc(tc(lsp2mason.cfg_file, lsp2mason.cfg_no), lsp2mason.formatter)

mason.setup({})
mason_lspconfig.setup({
    ensure_installed = ensure_installed,
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

for key in ipairs(lsp2mason.cfg_file) do
    local config = require('lsp.' .. key)
    config['capabilities'] = capabilities
    lspconfig[key].setup(config)
end

for key in ipairs(lsp2mason.cfg_no) do
    local config = {}
    config['capabilities'] = capabilities
    lspconfig[key].setup(config)
end
