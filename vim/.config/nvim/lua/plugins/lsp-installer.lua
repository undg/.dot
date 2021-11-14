local lsp_installer = require('nvim-lsp-installer')

-- Table with individual language servers settings.
local lsp_opt = {}
lsp_opt.denols = require('lsp/denols')
lsp_opt.tailwindcss = require('lsp/tailwindcss')
lsp_opt.jsonls = require('lsp/jsonls')

lsp_opt.sumneko_lua = require('lsp/sumneko_lua')
lsp_opt.yamlls = require('lsp/yamlls')

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    for k, v in pairs(lsp_opt)
        do
        if server.name == k then
            opts = v
        end
    end

    opts.capabilities = capabilities

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
    server:setup(opts)
end)
