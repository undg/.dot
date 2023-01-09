local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_ok or not mason_lspconfig_ok then
    print('lsp/init.lua: require failed')
end


local servers_with_config_files = {
    'denols',
    'jsonls',
    'tsserver',
    'yamlls',
    'sumneko_lua',
    -- "tailwindcss",
}

local servers_with_no_configs = {
    'cssls',
    -- "grammarly", -- testing: replacement for Gramarous
    'html',
    'prosemd_lsp', -- md
    -- "graphql",
    "clangd", -- c, cpp, objc, objcpp, cuda, proto
}

local ensure_installed = TableConcat(servers_with_config_files, servers_with_no_configs)

mason.setup({})
mason_lspconfig.setup({
    ensure_installed = ensure_installed,
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, name in ipairs(servers_with_config_files) do
    local config = require('lsp.' .. name)
    config['capabilities'] = capabilities
    lspconfig[name].setup(config)
end

for _, name in ipairs(servers_with_no_configs) do
    local config = {}
    config['capabilities'] = capabilities
    lspconfig[name].setup(config)
end
