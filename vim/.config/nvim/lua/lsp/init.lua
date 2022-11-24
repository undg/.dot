local servers_with_config_files = {
    "denols",
    "jsonls",
    "tsserver",
    "yamlls",
    -- "tailwindcss",
}

local servers_without_configs = {
    "cssls",
    "grammarly", -- testing: replacement for Gramarous
    "html",
    "prosemd_lsp", -- md
    "sumneko_lua",
    -- "graphql",
}

require("mason").setup({})

require("mason-lspconfig").setup({
    ensure_installed = {
        "denols",
        "jsonls",
        "tsserver",
        "yamlls",
        --
        "cssls",
        "grammarly", -- testing: replacement for Gramarous
        "html",
        "prosemd_lsp", -- md
        "sumneko_lua",
        -- "graphql",
    },
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()


for _, name in ipairs(servers_with_config_files) do
    local config = require("lsp." .. name)
    config["capabilities"] = capabilities
    lspconfig[name].setup(config)
end

for _, name in ipairs(servers_without_configs) do
    local config = {}
    config["capabilities"] = capabilities
    lspconfig[name].setup(config)
end
