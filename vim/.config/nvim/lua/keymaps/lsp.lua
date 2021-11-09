local map = require'../utils/map'

-- FzfLua, Lspsaga and native nvim.lsp
-- Mix of everything WIP

map.normal('gd', ':FzfLua lsp_definitions<CR>')
map.normal('gD', ':FzfLua lsp_declaration<CR>')
map.normal('gt', ':FzfLua lsp_typedefs<CR>')
-- map.normal('gr', ':FzfLua lsp_references<CR>')
map.normal('gi', ':FzfLua lsp_implementations<CR>')
-- map.normal('ga', ':FzfLua lsp_code_actions<CR>')

-- map.normal('K', ':lua vim.lsp.buf.hover()<CR>')
-- map.normal('<leader>rn', ':lua vim.lsp.buf.rename()<CR>')

-- map.normal(']e', ':Lspsaga diagnostics_jump_next<cr>')
-- map.normal('[e', ':Lspsaga diagnostics_jump_prev<cr>')

-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', ':lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', ':lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', ':lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)


map.normal("<LEADER>rn", ":Lspsaga rename<cr>", {silent = true, noremap = true})
map.normal("ga", ":Lspsaga code_action<cr>", {silent = true, noremap = true})
map.visual("ga", ":<c-u>Lspsaga range_code_action<cr>", {silent = true, noremap = true})
map.normal("K",  ":Lspsaga hover_doc<cr>", {silent = true, noremap = true})
map.normal("go", ":Lspsaga show_line_diagnostics<cr>", {silent = true, noremap = true})
map.normal("gj", ":Lspsaga diagnostic_jump_next<cr>zz", {silent = true, noremap = true})
map.normal("gk", ":Lspsaga diagnostic_jump_prev<cr>zz", {silent = true, noremap = true})
map.normal("<C-u>", ":lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")
map.normal("<C-d>", ":lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")

