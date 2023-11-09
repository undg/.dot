local keymap = require('utils.keymap')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- @TODO (undg) 2022-12-26: investigate how to preserve window resize functionality by mouse/touch
-- Don't go visual, stay normal. Disable mouse LeftDrag
keymap.normal('<LeftDrag>', '<LeftMouse>')

-- No fcking way! Nope, I don't want ex mode!
keymap.normal('Q', '<Nop>')
-- Stop that stupid window from popping up!
keymap.normal('q:', ':q')

-- Quickly quit
keymap.normal('<leader>q', ':q')

-- no need for ESC
keymap.insert('jk', '<ESC>')

-- write only
keymap.normal('<LEADER><LEADER>', ':wa<CR>')
keymap.normal('<c-space>', ':wa<CR>')
keymap.normal('<LEADER><CR>', ':write<CR>')
keymap.normal(';w', ':write<CR>')
keymap.normal(';a', ':wall<CR>')
-- quit only
-- map.normal("QQ", ":q<CR>") -- align with ZZ, that is default keybinding for write and quit
keymap.normal('XX', ':q!<CR>') -- easier ZQ, quit don't save

-- redo last macro
keymap.normal('<CR>', '@@')

-- cd to current file path
keymap.normal('<LEADER>cd', ':lcd %:p:h<CR>')

-- remove white spaces on end line
keymap.normal('<LEADER>sp', ':%s/\\s\\+$//ge<CR>:echomsg "white space cleaing"<cr>')

-- Toggle list (display unprintable characters).
keymap.normal('<F10>', ':set list!<CR>')
keymap.insert('<F10>', '<esc>:set list!<CR>i')

-- get git branch go into insert mode.
-- map.normal('<leader>gb', ':0r!git rev-parse --abbrev-ref HEAD<CR>A:<SPACE>')
keymap.normal('<leader>gb', ':0r! git rev-parse --abbrev-ref HEAD | awk -F "-" "{print \\$1 \\"-\\" \\$2 \\": \\"}" <CR>A')

-- indent, highlight in visual stay
keymap.visual('>', '>gv')
keymap.visual('<', '<gv')

-- ts/sw 2<-->4 toggle indentation
keymap.normal('<leader>st', ':ToggleIndent<cr>', { silent = false })

-- Yanking/Pasting/Copy
-- map.normal('<leader>p', '"+p')
keymap.visual('<C-C>', '"+y')
keymap.insert('<C-v>', '<c-o>"+P')
keymap.visual('<C-v>', 'd"+P')
-- Only visual, keep same yank in register
keymap.visual('<LEADER>p', '"_dP')
-- Copy all
keymap.normal('<LEADER>cc', 'ggVG"+y')

-- Keep it in center
keymap.normal('n', 'nzz')
keymap.normal('N', 'Nzz')
keymap.normal("''", "''zz")

keymap.visual('n', 'nzzzv')
keymap.visual('N', 'Nzzzv')
keymap.visual("''", "''zzzv")

keymap.normal('J', 'mzJ`z')
keymap.normal('<C-n>', ':cnext<CR>zzzv')
keymap.normal('<C-p>', ':cprev<CR>zzzv')

-- Extra break points
keymap.insert(',', ',<C-g>u')
keymap.insert('.', '.<C-g>u')
keymap.insert('!', '!<C-g>u')
keymap.insert('?', '?<C-g>u')

-- Remap for dealing with word wrap
keymap.normal('k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap.normal('j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Annihilate semicolons!!! 💀
keymap.normal("<leader>;", ":%s/;$//g<cr>'':noh<cr>")

-- Disable highlight till next search
keymap.normal('<leader>/', ':noh<cr>')

-- Substitute search and replace
keymap.normal('S', ':%s/')
keymap.visual('<leader>S', 'y:%s/\\(<c-r>0\\)')

-- Don't jump to next/prev. Wait for me! At least jump back.
-- this is overriden in nvim-hlslens
keymap.normal('*', '*N')
keymap.normal('#', '#N')

-- 3 way diffsplit (merge conflicts)
keymap.normal('gh', ':diffget //2<cr>')
keymap.normal('gl', ':diffget //3<cr>')
keymap.normal('gp', ':diffput //1<cr>')
