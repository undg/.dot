require("nvim-lsp-installer").setup({})
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers_with_cfg = {
    "denols",
    "tsserver",
    "yamlls",
    "jsonls",
    -- "tailwindcss",
}

local servers_no_cfg = {
    "sumneko_lua",

    -- "grammarly", -- testing: replacement for Gramarous
    "prosemd_lsp", -- md
    "cssls",
    -- "graphql",
    "html",
}
for _, name in ipairs(servers_with_cfg) do
    local config = require("lsp." .. name)
    config["capabilities"] = capabilities
    lspconfig[name].setup(config)
end

for _, name in ipairs(servers_no_cfg) do
    lspconfig[name].setup({
        capabilities = capabilities,
    })
end

-- @TODO (undg) 2022-11-07: delete it
-- lspconfig.denols.setup({
--     capabilities = capabilities,
--     root_dir = lspconfig.util.root_pattern("deno.json", "mod.ts"),
--     -- autostart = false,
--     single_file_support = false,
--     init_options = {
--         lint = true,
--     },
-- })

-- lspconfig.tsserver.setup({
--     capabilities = capabilities,
--     root_dir = lspconfig.util.root_pattern("package.json"),
--
--     on_attach = function()
--         local ts_utils = require("typescript")
--
--         ts_utils.setup({
--             debug = false,
--             disable_commands = false,
--             enable_import_on_completion = false,
--
--             -- import all
--             import_all_timeout = 500, -- ms
--             -- lower numbers = higher priority
--             import_all_priorities = {
--                 same_file = 1, -- add to existing import statement
--                 local_files = 2, -- git files or files with relative path markers
--                 buffer_content = 3, -- loaded buffer content
--                 buffers = 4, -- loaded buffer names
--             },
--             import_all_scan_buffers = 100,
--             import_all_select_source = false,
--             -- if false will avoid organizing imports
--             always_organize_imports = true,
--
--             -- filter diagnostics
--             filter_out_diagnostics_by_severity = {},
--             filter_out_diagnostics_by_code = {},
--
--             -- inlay hints
--             auto_inlay_hints = false,
--             inlay_hints_highlight = "Comment",
--             inlay_hints_priority = 200, -- priority of the hint extmarks
--             inlay_hints_throttle = 150, -- throttle the inlay hint request
--             inlay_hints_format = { -- format options for individual hint kind
--                 Type = {},
--                 Parameter = {},
--                 Enum = {},
--                 -- Example format customization for `Type` kind:
--                 -- Type = {
--                 --     highlight = "Comment",
--                 --     text = function(text)
--                 --         return "->" .. text:sub(2)
--                 --     end,
--                 -- },
--             },
--
--             -- update imports on file move
--             update_imports_on_move = true,
--             require_confirmation_on_move = true,
--             watch_dir = nil,
--         })
--     end,
-- })

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
