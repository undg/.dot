local keymap_ok, keymap = pcall(require, 'utils.keymap')
local tb_ok, telescope_builtin = pcall(require, 'telescope.builtin')
local t_ok, t = pcall(require, 'telescope')
local lspsaga_ok = pcall(require, 'lspsaga')
local typescript_ok = pcall(require, 'typescript-tools')

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

keymap.normal('<LEADER>p', function()
    vim.lsp.buf.format({ timeout_ms = 2000, async = true })
end, { desc = 'lsp: format' })
keymap.normal('<LEADER>rn', vim.lsp.buf.rename, { desc = 'lsp: rename', silent = false, noremap = true })
keymap.normal(
    '<LEADER>rfn',
    ':TSToolsRenameFile sync<CR>',
    { desc = 'lsp: rename_file', silent = false, noremap = true }
)
keymap.normal('<LEADER>ri', ':TSToolsOrganizeImports<cr>', { desc = 'lsp: Organize import', silent = false, noremap = true })
keymap.normal('<LEADER>ru', ':TSToolsRemoveUnused<cr>', { desc = 'lsp: Organize import', silent = false, noremap = true })
keymap.normal('K', function()
    if vim.bo.filetype == 'help' then
        vim.api.nvim_feedkeys('K', 'ni', true)
    else
        vim.lsp.buf.hover()
    end
end, { desc = 'lsp: hover / help: go to ref', silent = true, noremap = true })
keymap.normal('<leader>K', vim.lsp.buf.signature_help, { desc = 'lsp: signature_help', silent = true, noremap = true })
keymap.normal('ga', vim.lsp.buf.code_action, { desc = 'lsp: code_action' })
keymap.visual('ga', vim.lsp.buf.code_action, { desc = 'lsp: code_action' })

keymap.normal('<leader>Gd', ':Lspsaga peek_definition<CR>', { desc = 'lsp: peek_definition' })
keymap.normal('Gd', ':Lspsaga peek_definition<CR>', { desc = 'lsp: peek_definition' })

keymap.normal('<leader>GD', ':Lspsaga peek_type_definition<CR>', { desc = 'lsp: peek_type_definition' })
keymap.normal('GD', ':Lspsaga peek_type_definition<CR>', { desc = 'lsp: peek_type_definition' })

keymap.normal('<leader>gd', vim.lsp.buf.definition, { desc = 'lsp: definition' })
keymap.normal('gd', function()
    telescope_builtin.lsp_definitions(tb_opt)
end, { desc = 'lsp: definition (telescope)' })

keymap.normal('<leader>gD', vim.lsp.buf.type_definition, { desc = 'lsp: type_definition' })
keymap.normal('gD', function()
    telescope_builtin.lsp_type_definitions(tb_opt)
end, { desc = 'lsp: type_definition (telescope)' })

keymap.normal('<leader>gr', vim.lsp.buf.references, { desc = 'lsp: references' })
keymap.normal('grr', function()
    telescope_builtin.lsp_references(tb_opt)
end, { desc = 'lsp: references (telescope)' })
-- vim.keymap.set('n', '<leader>gr', function()
--     vim.fn.jobstart()
--     vim.lsp.buf.references()
--     vim.cmd('cclose')
--     telescope_builtin.quickfix()
--     -- telescope_builtin.lsp_references(tb_opt)
-- end)

keymap.normal('grf', ':TSToolsFileReferences sync', { desc = 'lsp: show file references' })

keymap.normal('<leader>gi', vim.lsp.buf.implementation, { desc = 'lsp: implementation' })
keymap.normal('gi', function()
    telescope_builtin.lsp_implementations(tb_opt)
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
