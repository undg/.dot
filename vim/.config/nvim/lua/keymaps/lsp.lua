local map_ok, map = pcall(require, 'utils.map')
local tb_ok, tb = pcall(require, 'telescope.builtin')
local lspsaga_ok = pcall(require, 'lspsaga')
-- local lspsaga_action_ok = pcall(require, 'lspsaga.action')
local typescript_ok = pcall(require, 'typescript')

if --
    not map_ok
    or not lspsaga_ok
    or not tb_ok
    or not typescript_ok
then
    print("keymaps/lsp.lua: requirement's fail")
    return
end

local tb_opt = {
    fname_width = 0.5,
    trim_text = false,
    show_line = false,
    include_current_line = false,
}

map.normal('<LEADER>p', vim.lsp.buf.format)
map.normal('<LEADER>rn', vim.lsp.buf.rename, { silent = false, noremap = true })
map.normal('<LEADER>rfn', ':TypescriptRenameFile<CR>', { silent = false, noremap = true })
map.normal('K', vim.lsp.buf.hover, { silent = true, noremap = true })
map.normal('KK', vim.lsp.buf.signature_help, { silent = true, noremap = true })
map.normal('ga', vim.lsp.buf.code_action)

map.normal('<leader>gd', ':Lspsaga peek_definition<CR>')
map.normal('<leader>gD', ':Lspsaga peek_type_definition<CR>')

map.normal('gd', function()
    tb.lsp_definitions(tb_opt)
end)
map.normal('gD', function()
    tb.lsp_type_definitions(tb_opt)
end)

map.normal('gr', function()
    tb.lsp_references(tb_opt)
end)
map.normal('gi', function()
    tb.lsp_implementations(tb_opt)
end)

map.normal('gj', vim.diagnostic.goto_next, { silent = true, noremap = true })
map.normal('gk', vim.diagnostic.goto_prev, { silent = true, noremap = true })
map.normal('gh', vim.diagnostic.open_float, { silent = true, noremap = true })

local styled = {
    border = 'rounded',
    style = 'minimal',
    noautocmd = true,
}

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
