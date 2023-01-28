local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
local null_ls_ok, null_ls = pcall(require, 'null-ls')
local mason_installer_ok, mason_installer = pcall(require, 'mason-tool-installer')

if not lspconfig_ok
    or not cmp_nvim_lsp_ok
    or not mason_ok
    or not mason_lspconfig_ok
    or not mason_installer_ok
    or not null_ls_ok
then
    print('lsp/init.lua: require failed')
    return
end

-- Lsp server name is same as file name with config.
-- [key: type] = {
--      [key: lsp server name] = 'mason pkg name'
-- }
local lsp2mason = {
    cfg_file = {
        denols = 'deno',
        jsonls = 'json-lsp',
        tsserver = 'typescript-language-server',
        yamlls = 'yaml-language-server',
        sumneko_lua = 'lua-language-server',
    },
    cfg_no = {
        cssls = 'cssls',
        html = 'html',
        -- prosemd_lsp = 'prosemd-lsp',
        clangd = 'clangd',
        -- pyright = 'pyright',
        pylsp = 'python-lsp-server',
        marksman = 'marksman',
        bashls='bash-language-server',
        gopls='gopls',
    },
}

local fn = vim.fn
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua.with({
            extra_args = {
                '--config-path',
                fn.expand('~/.config/stylua/stylua.toml'),
            },
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.goimports,

        null_ls.builtins.diagnostics.eslint_d,
        -- null_ls.builtins.diagnostics.actionlint,
        -- null_ls.builtins.diagnostics.markdownlint,
        -- null_ls.builtins.diagnostics.proselint,

        -- null_ls.builtins.completion.spell,
        null_ls.builtins.completion.tags,

        null_ls.builtins.hover.dictionary,
    },
})

-- Non lsp Mason packages to auto install. Package name
local mason_non_lsp = {
    'stylua',
    'prettierd',
    'shfmt', -- format sh
    'fixjson', -- format json
    'black', -- format python

    'eslint_d', -- js diagnostic
    'actionlint', -- github action files diagnostic
    -- 'markdownlint', -- md diagnostic
    -- 'proselint',
    'goimports-reviser',
}

-- Lsp server names that will be installed via Manson
local mason_lsp = {}

mason.setup({})

local capabilities = cmp_nvim_lsp.default_capabilities()

for key in pairs(lsp2mason.cfg_file) do
    mason_lsp[#mason_lsp + 1] = key
    local config = require('lsp.' .. key)
    config['capabilities'] = capabilities
    lspconfig[key].setup(config)
end

for key in pairs(lsp2mason.cfg_no) do
    mason_lsp[#mason_lsp + 1] = key
    local config = {}
    config['capabilities'] = capabilities
    lspconfig[key].setup(config)
end

mason_lspconfig.setup({
    ensure_installed = mason_lsp,
})
mason_installer.setup({
    ensure_installed = mason_non_lsp,
})
