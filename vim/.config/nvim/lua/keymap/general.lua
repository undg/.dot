local map = require('utils.map')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- @TODO (undg) 2022-12-26: investigate how to preserve window resize functionality by mouse/touch
-- Don't go visual, stay normal. Disable mouse LeftDrag
map.normal('<LeftDrag>', '<LeftMouse>')

-- No fcking way! Nope, I don't want ex mode!
map.normal('Q', '<Nop>')
-- Stop that stupid window from popping up!
map.normal('q:', ':q')

-- no need for ESC
map.insert('jk', '<ESC>')

-- write only
map.normal('<LEADER><LEADER>', ':wa<CR>')
map.normal('<c-space>', ':wa<CR>')
map.normal('<LEADER><CR>', ':write<CR>')
map.normal(';w', ':write<CR>')
map.normal(';a', ':wall<CR>')
-- quit only
-- map.normal("QQ", ":q<CR>") -- align with ZZ, that is default keybinding for write and quit
map.normal('XX', ':q!<CR>') -- easier ZQ, quit don't save

-- redo last macro
map.normal('<CR>', '@@')

-- cd to current file path
map.normal('<LEADER>cd', ':lcd %:p:h<CR>')

-- remove white spaces on end line
map.normal('<LEADER>sp', ':%s/\\s\\+$//ge<CR>:echomsg "white space cleaing"<cr>')

-- Toggle list (display unprintable characters).
map.normal('<F10>', ':set list!<CR>')
map.insert('<F10>', '<esc>:set list!<CR>i')

-- get git branch go into insert mode.
-- map.normal('<leader>gb', ':0r!git rev-parse --abbrev-ref HEAD<CR>A:<SPACE>')
map.normal('<leader>gb', ':0r! git rev-parse --abbrev-ref HEAD | awk -F "-" "{print \\$1 \\"-\\" \\$2 \\": \\"}" <CR>A')

-- indent, highlight in visual stay
map.visual('>', '>gv')
map.visual('<', '<gv')

-- ts/sw 2<-->4 toggle indentation
map.normal('<leader>st', ':ToggleIndent<cr>', { silent = false })

-- Yanking/Pasting/Copy
-- map.normal('<leader>p', '"+p')
map.visual('<C-C>', '"+y')
map.insert('<C-v>', '<c-o>"+P')
map.visual('<C-v>', 'd"+P')
-- Only visual, keep same yank in register
map.visual('<LEADER>p', '"_dP')
-- Copy all
map.normal('<LEADER>cc', 'ggVG"+y')

-- Keep it in center
map.normal('n', 'nzz')
map.normal('N', 'Nzz')
map.normal("''", "''zz")

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

-- Remap for dealing with word wrap
map.normal('k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map.normal('j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Annihilate semicolons!!! 💀
map.normal("<leader>;", ":%s/;$//g<cr>'':noh<cr>")

-- Disable highlight till next search
map.normal('<leader>/', ':noh<cr>')

-- Substitute search and replace
map.normal('S', ':%s/')
map.visual('<leader>S', 'y:%s/<c-r>0')

-- Don't jump to next/prev. Wait for me! At least jump back.
-- this is overriden in nvim-hlslens
map.normal('*', '*N')
map.normal('#', '#N')

-- 3 way diffsplit (merge conflicts)
map.normal('gh', ':diffget //2<cr>')
map.normal('gl', ':diffget //3<cr>')
map.normal('gp', ':diffput //1<cr>')
