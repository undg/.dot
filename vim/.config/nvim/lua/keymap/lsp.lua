local map_ok, map = pcall(require, 'utils.map')
local tb_ok, tb = pcall(require, 'telescope.builtin')
local t_ok, t = pcall(require, 'telescope')
local lspsaga_ok = pcall(require, 'lspsaga')
-- local lspsaga_action_ok = pcall(require, 'lspsaga.action')
local typescript_ok = pcall(require, 'typescript')

if --
    not map_ok
    or not lspsaga_ok
    or not tb_ok
    or not t_ok
    or not typescript_ok
then
    print("keymap/lsp.lua: requirement's fail")
    return
end

local tb_opt = {
    fname_width = 0.5,
    trim_text = false,
    show_line = false,
    include_current_line = true,
}

map.normal('<LEADER>p', vim.lsp.buf.format)
map.normal('<LEADER>rn', vim.lsp.buf.rename, { silent = false, noremap = true })
map.normal('<LEADER>rfn', ':TypescriptRenameFile<CR>', { silent = false, noremap = true })
map.normal('K', vim.lsp.buf.hover, { silent = true, noremap = true })
map.normal('KK', vim.lsp.buf.signature_help, { silent = true, noremap = true })
map.normal('ga', vim.lsp.buf.code_action)
map.visual('ga', vim.lsp.buf.code_action)

map.normal('<leader>Gd', ':Lspsaga peek_definition<CR>')
map.normal('Gd', ':Lspsaga peek_definition<CR>')

map.normal('<leader>GD', ':Lspsaga peek_type_definition<CR>')
map.normal('GD', ':Lspsaga peek_type_definition<CR>')

map.normal('<leader>gd', vim.lsp.buf.definition)
map.normal('gd', function()
    tb.lsp_definitions(tb_opt)
end)

map.normal('<leader>gD', vim.lsp.buf.type_definition)
map.normal('gD', function()
    tb.lsp_type_definitions(tb_opt)
end)

map.normal('<leader>gr', vim.lsp.buf.references)
map.normal('gr', function()
    tb.lsp_references(tb_opt)
end)
-- vim.keymap.set('n', '<leader>gr', function()
--     vim.lsp.buf.references()
--     -- vim.cmd('cclose')
--     tb.quickfix()
--     -- tb.lsp_references(tb_opt)
-- end)


map.normal('<leader>gi', vim.lsp.buf.implementation)
map.normal('gi', function()
    tb.lsp_implementations(tb_opt)
end)

map.normal(
    'gj',
    ':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, })<cr>',
    { silent = true, noremap = true }
)
map.normal('GJ', vim.diagnostic.goto_next, { silent = true, noremap = true })
map.normal(
    'gk',
    ':lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, })<cr>',
    { silent = true, noremap = true }
)
map.normal('GK', vim.diagnostic.goto_prev, { silent = true, noremap = true })
map.normal('gh', vim.diagnostic.open_float, { silent = true, noremap = true })

local styled = {
    border = 'rounded',
    style = 'minimal',
    noautocmd = true,
}

-- @TODO (undg) 2023-09-06: movie it to UI stuff.
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, styled)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, styled)

vim.diagnostic.config({
    float = {
        border = styled.border,
        header = 'diagnostic:',
        source = true,
        prefix = '  ', -- padding left
        suffix = '  ', -- padding right
    },
})
