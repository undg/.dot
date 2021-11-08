local saga = require('lspsaga')
local map = require('../utils/map')

-- use default config
-- saga.init_lsp_saga()

map.normal('gh', ':Lspsaga lsp_finder<CR>', {silent = true})

map.normal('<leader>ca', ':Lspsaga code_action<CR>', {silent = true})
map.visual('<leader>ca', ':<C-U>Lspsaga range_code_action<CR>', {silent = true})

-- Hover Doc
map.normal('K', ':Lspsaga hover_doc<CR>', {silent = true})
map.normal('gs', ':Lspsaga signature_help<CR>', {silent = true})
-- map.normal('gd', ':Lspsaga preview_definition<CR>', {silent = true})

-- scroll up/down hover doc, signature help or scroll in definition preview
map.normal('<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', {silent = true})
map.normal('<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', {silent = true})

map.normal('<leader>rn', ':Lspsaga rename<CR>', {silent = true})
-- close rename win use <C-c> in insert mode or `q` in noremal mode or `:q`

map.normal('<leader>cd', ':Lspsaga show_line_diagnostics<CR>', {silent = true})
map.normal('<leader>cc', ':Lspsaga show_cursor_diagnostics<CR>', {silent = true})
map.normal('[e', ':Lspsaga diagnostic_jump_next<CR>', {silent = true})
map.normal(']e', ':Lspsaga diagnostic_jump_prev<CR>', {silent = true})




-- or add your config value here (default values)
saga.init_lsp_saga {
	-- use_saga_diagnostic_sign = true
	-- error_sign = '',
	-- warn_sign = '',
	-- hint_sign = '',
	-- infor_sign = '',
	-- dianostic_header_icon = '   ',
	-- code_action_icon = ' ',
	-- code_action_prompt = {
	--   enable = true,
	--   sign = true,
	--   sign_priority = 20,
	--   virtual_text = true,
	-- },
	-- finder_definition_icon = '  ',
	-- finder_reference_icon = '  ',
	-- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
	finder_action_keys = {
	  open = 'o', vsplit = 's',split = 'i',quit = '<ESC><ESC>',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
	},
	code_action_keys = {
	  quit = '<ESC><ESC>',exec = '<CR>'
	},
	rename_action_keys = {
	  quit = '<ESC><ESC>',exec = '<CR>'  -- quit can be a table
	},
	-- definition_preview_icon = '  '
	-- "single" "double" "round" "plus"
	-- border_style = "single"
	-- rename_prompt_prefix = '➤',
	-- if you don't use nvim-lspconfig you must pass your server name and
	-- the related filetypes into this table
	-- like server_filetype_map = {metals = {'sbt', 'scala'}}
	-- server_filetype_map = {}
}
