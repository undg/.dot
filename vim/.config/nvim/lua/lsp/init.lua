local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
local null_ls_ok, null_ls = pcall(require, 'null-ls')
local mason_installer_ok, mason_installer = pcall(require, 'mason-tool-installer')

if
    not lspconfig_ok
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
        lua_ls = 'lua-language-server',
        eslint = 'eslint',
    },
    cfg_no_file = {
        cssls = 'cssls',
        html = 'html',
        -- prosemd_lsp = 'prosemd-lsp',
        clangd = 'clangd',
        -- pyright = 'pyright',
        pylsp = 'python-lsp-server',
        marksman = 'marksman',
        bashls = 'bash-language-server',
        gopls = 'gopls',
    },
}

null_ls.setup({
    sources = {
        -- null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.prettier.with({
             prefer_local= 'node_modules/.bin',
        }),
        null_ls.builtins.formatting.stylua.with({
            extra_args = {
                '--config-path',
                vim.fn.expand('~/.config/stylua/stylua.toml'),
            },
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.goimports,

        -- null_ls.builtins.diagnostics.actionlint,
        -- null_ls.builtins.diagnostics.markdownlint,
        -- null_ls.builtins.diagnostics.proselint,
        -- null_ls.builtins.diagnostics.prettier,

        -- null_ls.builtins.completion.spell,
        null_ls.builtins.completion.tags,

        null_ls.builtins.hover.dictionary,
        require('typescript.extensions.null-ls.code-actions'),
    },
})

-- Non lsp Mason packages to auto install. Package name
local mason_non_lsp = {
    'stylua',
    'prettier',
    'shfmt',      -- format sh
    'fixjson',    -- format json
    'black',      -- format python

    'actionlint', -- github action files diagnostic
    -- 'markdownlint', -- md diagnostic
    -- 'proselint', -- grammarly like engine
    'goimports-reviser',
}

-- Lsp server names that will be installed via Manson
local mason_lsp = {} -- mutate

mason.setup({})

local capabilities = cmp_nvim_lsp.default_capabilities()

for name in pairs(lsp2mason.cfg_file) do
    mason_lsp[#mason_lsp + 1] = name
    local config = require('lsp.' .. name)
    config['capabilities'] = capabilities
    lspconfig[name].setup(config)
end

for name in pairs(lsp2mason.cfg_no_file) do
    mason_lsp[#mason_lsp + 1] = name
    local config = {}
    config['capabilities'] = capabilities
    lspconfig[name].setup(config)
end

mason_lspconfig.setup({
    ensure_installed = mason_lsp,
})
mason_installer.setup({
    ensure_installed = mason_non_lsp,
})
