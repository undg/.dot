local servers_with_config_files = {
    "denols",
    "jsonls",
    "tsserver",
    "yamlls",
    "sumneko_lua",
    -- "tailwindcss",
}

local servers_with_no_configs = {
    "cssls",
    -- "grammarly", -- testing: replacement for Gramarous
    "html",
    "prosemd_lsp", -- md
    -- "graphql",
}

local ensure_installed = TableConcat(servers_with_config_files, servers_with_no_configs)

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = ensure_installed
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, name in ipairs(servers_with_config_files) do
    local config = require("lsp." .. name)
    config["capabilities"] = capabilities
    lspconfig[name].setup(config)
end

for _, name in ipairs(servers_with_no_configs) do
    local config = {}
    config["capabilities"] = capabilities
    lspconfig[name].setup(config)
end

