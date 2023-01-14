local map_ok, map = pcall(require, "utils.map")
local tb_ok, tb = pcall(require, 'telescope.builtin')
local lspsaga_ok = pcall(require, 'lspsaga')
local lspsaga_action_ok = pcall(require, 'lspsaga.action')

if not lspsaga_ok or not lspsaga_action_ok or not tb_ok or not map_ok then
    print("keymaps/lsp.lua: requirement's fail")
    return
end

local tb_opt = { fname_width = 0.5, trim_text = true }

map.normal("<LEADER>p", vim.lsp.buf.format)
map.normal("<LEADER>rn", vim.lsp.buf.rename, { silent = false, noremap = true })
map.normal("K", vim.lsp.buf.hover, { silent = true, noremap = true })
map.normal('<C-k>', vim.lsp.buf.signature_help)
map.normal("ga", vim.lsp.buf.code_action)

map.normal("gd", function() tb.lsp_definitions(tb_opt) end)
map.normal("gD", function() tb.lsp_type_definitions(tb_opt) end)
map.normal("gr", function() tb.lsp_references(tb_opt) end)
map.normal("gi", function() tb.lsp_implementations(tb_opt) end)

map.normal("gj", ":Lspsaga diagnostic_jump_next<cr>zz", { silent = true, noremap = true })
map.normal("gk", ":Lspsaga diagnostic_jump_prev<cr>zz", { silent = true, noremap = true })

map.normal("<C-u>", ":lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")
map.normal("<C-d>", ":lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")

