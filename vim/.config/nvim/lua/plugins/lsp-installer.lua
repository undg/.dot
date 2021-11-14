local lsp_installer = require('nvim-lsp-installer')
local lsp_opt = {}

lsp_opt.tsserver = require('lsp/tsserver')
lsp_opt.sumneko_lua = require('lsp/sumneko_lua')
lsp_opt.yamlls = require('lsp/yamlls')
lsp_opt.jsonls = require('lsp/jsonls')


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
