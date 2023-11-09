local keymap_ok, keymap = pcall(require, 'utils.keymap')
local tb_ok, tb = pcall(require, 'telescope.builtin')
local t_ok, t = pcall(require, 'telescope')
local lspsaga_ok = pcall(require, 'lspsaga')
-- local lspsaga_action_ok = pcall(require, 'lspsaga.action')
local typescript_ok = pcall(require, 'typescript')

if --
    not keymap_ok
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

keymap.normal('<LEADER>p', vim.lsp.buf.format)
keymap.normal('<LEADER>rn', vim.lsp.buf.rename, { silent = false, noremap = true })
keymap.normal('<LEADER>rfn', ':TypescriptRenameFile<CR>', { silent = false, noremap = true })
keymap.normal('K', vim.lsp.buf.hover, { silent = true, noremap = true })
keymap.normal('KK', vim.lsp.buf.signature_help, { silent = true, noremap = true })
keymap.normal('ga', vim.lsp.buf.code_action)
keymap.visual('ga', vim.lsp.buf.code_action)

keymap.normal('<leader>Gd', ':Lspsaga peek_definition<CR>')
keymap.normal('Gd', ':Lspsaga peek_definition<CR>')

keymap.normal('<leader>GD', ':Lspsaga peek_type_definition<CR>')
keymap.normal('GD', ':Lspsaga peek_type_definition<CR>')

keymap.normal('<leader>gd', vim.lsp.buf.definition)
keymap.normal('gd', function()
    tb.lsp_definitions(tb_opt)
end)

keymap.normal('<leader>gD', vim.lsp.buf.type_definition)
keymap.normal('gD', function()
    tb.lsp_type_definitions(tb_opt)
end)

keymap.normal('<leader>gr', vim.lsp.buf.references)
keymap.normal('gr', function()
    tb.lsp_references(tb_opt)
end)
-- vim.keymap.set('n', '<leader>gr', function()
--     vim.lsp.buf.references()
--     -- vim.cmd('cclose')
--     tb.quickfix()
--     -- tb.lsp_references(tb_opt)
-- end)

keymap.normal('<leader>gi', vim.lsp.buf.implementation, { desc = 'lsp: implementation' })
keymap.normal('gi', function()
    tb.lsp_implementations(tb_opt)
end, { desc = 'lsp: implementation (telescope)' })

keymap.normal(
    '<leader>gj',
    ':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, })<cr>',
    { silent = true, noremap = true, desc = 'lsp: diagnostic_goto_next ERROR' }
)
keymap.normal('gj', vim.diagnostic.goto_next, { silent = true, noremap = true, desc = 'lsp: diagnostic_goto_next' })
keymap.normal(
    '<leader>gk',
    ':lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, })<cr>',
    { silent = true, noremap = true, desc = 'lsp: diagnostic_goto_prev ERROR' }
)
keymap.normal('gk', vim.diagnostic.goto_prev, { silent = true, noremap = true, desc = 'lsp: diagnostic_goto_prev' })
keymap.normal('gh', vim.diagnostic.open_float, { silent = true, noremap = true, desc = 'lsp: diagnostic_open_float' })

