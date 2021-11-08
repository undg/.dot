local map = require('utils.map')

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Stop that stupid window from popping up!
map.normal('q:', ':q')
-- No fcking way! Nope, I don't want ex mode!
map.normal('Q', '<Nop>')

-- no need for ESC
map.insert('jk', '<ESC>')
map.insert('kj', '<ESC>')

-- ZZ like stuff
map.normal('<LEADER><LEADER>', ':write<CR>')
map.normal('<LEADER>q', ':q<CR>')

-- duno... I'm using it a lot.
map.normal('<LEADER>s', ':mksession!<CR>')
map.normal('<LEADER>cd', ':lcd %:p:h<CR>', {silent = true})

-- remove white spaces on end line
map.normal('<LEADER>sp', ':%s/\\s\\+$//ge<CR>:echomsg \"white space cleaing\"<cr>')

-- Toggle list (display unprintable characters).
map.normal('<F8>', ':set list!<CR>')
map.insert('<F8>', '<esc>:set list!<CR>i')

-- get git branch go into insert mode.
map.normal('<leader>gb', ':0r!git rev-parse --abbrev-ref HEAD<CR>A:<SPACE>')


-- pop-up selection (autocomplete)
map.insert('<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map.insert('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})

-- repeat last macro
-- map.normal('<CR>', '@@')

-- Yanking/Pasting
map.normal('<leader>p', '"+p')
map.visual('<leader>y', '"+y')
-- Yank to end of line
map.normal('Y', 'y$')
-- Only visual, keep same yank in register
map.visual('<LEADER>p', '"_dP')

-- Keep in center
map.normal('n', 'nzzzv')
map.normal('N', 'Nzzzv')
map.normal('J', 'mzJ`z')
map.normal('<C-n>', ':cnext<CR>zzzv')
map.normal('<C-p>', ':cprev<CR>zzzv')

-- Extra break points
map.insert(',', ',<C-g>u')
map.insert('.', '.<C-g>u')
map.insert('!', '!<C-g>u')
map.insert('?', '?<C-g>u')

-- LSP
map.normal('<LEADER>.', ':FzfLua files<CR>')
map.normal('<LEADER>m', ':FzfLua <CR>')
map.normal('<LEADER>b', ':FzfLua buffers<CR>')

map.normal('gd', ':FzfLua lsp_definitions<CR>')
map.normal('gr', ':FzfLua lsp_references<CR>')
map.normal('gi', ':FzfLua lsp_implementations<CR>')
map.normal('ga', ':FzfLua lsp_code_actions<CR>')

