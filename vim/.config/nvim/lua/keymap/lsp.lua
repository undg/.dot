local keymap_ok, keymap = pcall(require, 'utils.keymap')
local t_ok, t = pcall(require, 'telescope')
local lspsaga_ok = pcall(require, 'lspsaga')
local typescript_ok = pcall(require, 'typescript-tools')

if --
    not keymap_ok
    or not lspsaga_ok
    or not t_ok
    or not typescript_ok
then
    print("keymap/lsp.lua: requirement's fail")
    return
end

keymap.normal('<LEADER>p', function()
    vim.lsp.buf.format({ timeout_ms = 2000, async = true })
end, { desc = 'lsp: format' })
keymap.normal('<LEADER>rn', vim.lsp.buf.rename, { desc = 'lsp: rename', silent = false, noremap = true })
keymap.normal('<LEADER>rfn', ':TSToolsRenameFile sync<CR>', { desc = 'lsp: rename_file', silent = false, noremap = true })
keymap.normal(
    '<LEADER>ri',
    ':TSToolsOrganizeImports<cr>',
    { desc = 'lsp: Organize import', silent = false, noremap = true }
)
keymap.normal(
    '<LEADER>ru',
    ':TSToolsRemoveUnused<cr>',
    { desc = 'lsp: Organize import', silent = false, noremap = true }
)
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
keymap.normal('gd', ':Telescope lsp_definitions<cr>', { desc = 'lsp: definition (telescope)' })

keymap.normal('<leader>gD', vim.lsp.buf.type_definition, { desc = 'lsp: type_definition' })
keymap.normal('gD', ':Telescope lsp_type_definitions<cr>', { desc = 'lsp: type_definition (telescope)' })

keymap.normal('<leader>gr', vim.lsp.buf.references, { desc = 'lsp: references' })
keymap.normal('gr', ':Telescope lsp_references<cr>', { desc = 'lsp: references (telescope)' })

keymap.normal('gfr', ':TSToolsFileReferences<cr>', { desc = 'lsp: show file references' })

keymap.normal('<leader>gi', vim.lsp.buf.implementation, { desc = 'lsp: implementation' })
keymap.normal('gi', ':TSToolsGoToSourceDefinition<cr>', { desc = 'lsp: implementation (telescope)' })
keymap.normal('gI', ':Telescope lsp_implementations<cr>', { desc = 'lsp: implementation (telescope)' })

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
