require("nvim-lsp-installer").setup({})
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers_with_cfg = {
    -- "denols",
    "tsserver",
    "yamlls",
    "jsonls",
    "sumneko_lua",
    -- "tailwindcss",
}
local servers_no_cfg = {
    "grammarly", -- testing: replacement for Gramarous
    "prosemd_lsp", -- md
    "cssls",
    -- "graphql",
    "html",
}
for _, name in ipairs(servers_with_cfg) do
    lspconfig[name].setup({
        require('lsp.' .. name),
        capabilities = capabilities,
    })
end
for _, name in ipairs(servers_no_cfg) do
    lspconfig[name].setup({
        capabilities = capabilities,
    })
end

-- @TODO (undg) 2022-11-07: delete it 
-- lspconfig.tsserver.setup {
--     require("lsp.tsserver"),
--     capabilities = capabilities,
-- }
-- lspconfig.jsonls.setup {
--     require("lsp.jsonls"),
--     capabilities = capabilities,
-- }
-- lspconfig.yamlls.setup {
--     require("lsp.yamlls"),
--     capabilities = capabilities,
-- }

-- @TODO (undg) 2022-11-07: delete it in few days after testing new config
-- local lsp_installer = require('nvim-lsp-installer')
--
-- -- Table with individual language servers settings.
-- local lsp_opt = {}
-- lsp_opt.denols = require('lsp.denols')
-- lsp_opt.tailwindcss = require('lsp.tailwindcss')
-- lsp_opt.jsonls = require('lsp.jsonls')
--
-- lsp_opt.sumneko_lua = require('lsp.sumneko_lua')
-- lsp_opt.yamlls = require('lsp.yamlls')
-- lsp_opt.tsserver = require('lsp.tsserver')
--
-- -- nvim-cmp supports additional completion capabilities
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
--
-- lsp_installer.on_server_ready(function(server)
--     local opts = {}
--
--     for key, value in pairs(lsp_opt)
--         do
--         if server.name == key then
--             opts = value
--         end
--     end
--
--     opts.capabilities = capabilities
--
--     server:setup(opts)
-- end)
--
