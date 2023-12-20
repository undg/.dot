local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
local null_ls_ok, null_ls = pcall(require, 'null-ls')
local mason_installer_ok, mason_installer = pcall(require, 'mason-tool-installer')
local cspell_ok, cspell = pcall(require, 'cspell')

if
    not lspconfig_ok
    or not cmp_nvim_lsp_ok
    or not mason_ok
    or not mason_lspconfig_ok
    or not mason_installer_ok
    or not null_ls_ok
    or not cspell_ok
    -- or not typescript_code_action_ok
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
        -- tsserver = 'typescript-language-server',
        yamlls = 'yaml-language-server',
        lua_ls = 'lua-language-server',
        -- eslint = 'eslint_d',
        gopls = 'gopls',
    },
    cfg_no_file = {
        cssls = 'cssls',
        html = 'html',
        clangd = 'clangd',
        pylsp = 'python-lsp-server',
        marksman = 'marksman',
        bashls = 'bash-language-server',
        tailwindcss = 'tailwindcss-language-server',
    },
}

local M_null_ls_sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.completion.tags,
    null_ls.builtins.hover.dictionary,
}

if string.match(vim.fn.getcwd(), '/Arahi/') then
    print('null_ls: setup for arahi only')
    local arahi_sources = {
        cspell.diagnostics,
        cspell.code_actions,
    }
    vim.list_extend(M_null_ls_sources, arahi_sources)
else
    print('null_ls: universal setup')
    local universal_sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.goimports,
    }
    vim.list_extend(M_null_ls_sources, universal_sources)
end

null_ls.setup({
    sources = M_null_ls_sources,
})

-- Non lsp Mason packages to auto install. Package name
local mason_non_lsp = {
    'stylua',     -- format lua
    -- 'prettier',   -- format js/ts
    'shfmt',      -- format sh
    'fixjson',    -- format json
    'black',      -- format python

    'actionlint', -- github action files diagnostic
    'goimports-reviser',
    'goimports',
    'eslint_d',
    'eslint',
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
