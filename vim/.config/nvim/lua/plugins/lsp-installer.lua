local lsp_installer = require('nvim-lsp-installer')

-- Table with individual language servers settings.
local lsp_opt = {}
lsp_opt.denols = require('lsp.denols')
lsp_opt.tailwindcss = require('lsp.tailwindcss')
lsp_opt.jsonls = require('lsp.jsonls')

lsp_opt.sumneko_lua = require('lsp.sumneko_lua')
lsp_opt.yamlls = require('lsp.yamlls')
lsp_opt.tsserver = require('lsp.tsserver')

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lsp_installer.on_server_ready(function(server)
    local opts = {}

    for k, v in pairs(lsp_opt)
        do
        if server.name == k then
            opts = v
        end
    end

    opts.capabilities = capabilities

    server:setup(opts)
end)
