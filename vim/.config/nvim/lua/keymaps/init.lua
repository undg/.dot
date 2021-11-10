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
map.normal('<LEADER>s', ':mksession!<CR>', {silent = false})
map.normal('<LEADER>cd', ':lcd %:p:h<CR>')

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

-- Keep it in center
map.normal('n', 'nzzzv')
map.normal('N', 'Nzzzv')
map.normal("''", "''zzzv")

map.visual('n', 'nzzzv')
map.visual('N', 'Nzzzv')
map.visual("''", "''zzzv")

map.normal('J', 'mzJ`z')
map.normal('<C-n>', ':cnext<CR>zzzv')
map.normal('<C-p>', ':cprev<CR>zzzv')

-- Extra break points
map.insert(',', ',<C-g>u')
map.insert('.', '.<C-g>u')
map.insert('!', '!<C-g>u')
map.insert('?', '?<C-g>u')

map.normal('<LEADER>.', ':FzfLua files<CR>')
map.normal('<LEADER>m', ':FzfLua <CR>')
map.normal('<LEADER>b', ':FzfLua buffers<CR>')


-- Remap for dealing with word wrap
map.normal('k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map.normal('j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Y yank until the end of line  (note: this is now a default on master)
map.normal('Y', 'y$', { noremap = true })

-- Zoom / Fullscreen
map.normal('<C-w>z',     ':ZoomWinTabToggle<CR>')
map.normal('<C-w><C-z>', ':ZoomWinTabToggle<CR>')

map.normal('tt',         ':tabnew %<CR>')
map.normal('<C-w>t',     ':tabnew %<CR>')
map.normal('<C-w><C-t>', ':tabnew %<CR>')

