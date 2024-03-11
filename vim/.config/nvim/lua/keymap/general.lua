vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- @TODO (undg) 2022-12-26: investigate how to preserve window resize functionality by mouse/touch
-- Don't go visual, stay normal. Disable mouse LeftDrag
Keymap.normal('<LeftDrag>', '<LeftMouse>')

-- No fcking way! Nope, I don't want ex mode!
Keymap.normal('Q', '<Nop>')
-- Stop that stupid window from popping up!
Keymap.normal('q:', ':q')

-- Quickly quit
Keymap.normal('<leader>q', ':q<cr>')

-- no need for ESC
Keymap.insert('jk', '<ESC>')

-- write only
Keymap.normal('<LEADER><LEADER>', ':wa<CR>')
Keymap.normal('<c-space>', ':wa<CR>')
Keymap.normal('<LEADER><CR>', ':write<CR>')
-- quit only
Keymap.normal('ZZ', ':wq<cr>', { desc = 'write and quit' }) -- this is default keymap, remap to add description
Keymap.normal('ZA', ':wqa<cr>', { desc = 'write all and quit' })
Keymap.normal('QQ', ':q<CR>', { desc = 'quit' })
Keymap.normal('QA', ':qa<CR>', { desc = 'quit all' })
Keymap.normal('XX', ':q!<CR>', { desc = "force quit (don't save)" })
Keymap.normal('XA', ':qa!<CR>', { desc = "force quit all (don't save)" })

-- redo last macro
Keymap.normal('<CR>', '@@')

-- cd to current file path
Keymap.normal('<LEADER>cd', ':lcd %:p:h<CR>')

-- remove white spaces on end line
Keymap.normal(
    '<LEADER>sp',
    ':%s/\\s\\+$//ge|norm <CR>:echomsg "white space cleaing"<cr>',
    { desc = 'remove trailing whitespace' }
)

-- Toggle list (display unprintable characters).
Keymap.normal('<F10>', ':set list!<CR>')
Keymap.insert('<F10>', '<esc>:set list!<CR>i')

-- get git branch go into insert mode.
-- map.normal('<leader>gb', ':0r!git rev-parse --abbrev-ref HEAD<CR>A:<SPACE>')
Keymap.normal(
    '<leader>gb',
    ':0r! git rev-parse --abbrev-ref HEAD | awk -F "-" "{print \\$1 \\"-\\" \\$2 \\": \\"}" <CR>A',
    { desc = 'get git branch name' }
)

-- indent, highlight in visual stay
Keymap.visual('>', '>gv')
Keymap.visual('<', '<gv')

-- Yanking/Pasting/Copy
-- map.normal('<leader>p', '"+p')
Keymap.visual('<C-C>', '"+y')
Keymap.insert('<C-v>', '<c-o>"+P')
Keymap.visual('<C-v>', 'd"+P')
-- Only visual, keep same yank in register
Keymap.visual('<LEADER>p', '"_dP')
-- Copy all
Keymap.normal('<LEADER>cc', 'ggVG"+y')

-- Keep it in center (quality of life)
Keymap.normal('n', 'nzz')
Keymap.normal('N', 'Nzz')
Keymap.normal("''", "''zz")

Keymap.visual('n', 'nzzzv')
Keymap.visual('N', 'Nzzzv')
Keymap.visual("''", "''zzzv")

Keymap.normal('J', 'mzJ`z')
Keymap.normal('<C-n>', ':cnext<CR>zzzv')
Keymap.normal('<C-p>', ':cprev<CR>zzzv')

-- move selection up and down
Keymap.xisual('<C-k>', ':m -2<CR>gv=gv')
Keymap.xisual('<C-j>', ":m '>+<CR>gv=gv")
Keymap.visual('<C-k>', ':m -2<CR>gv=gv')
Keymap.visual('<C-j>', ":m '>+<CR>gv=gv")

-- Extra break points
Keymap.insert(',', ',<C-g>u')
Keymap.insert('.', '.<C-g>u')
Keymap.insert('!', '!<C-g>u')
Keymap.insert('?', '?<C-g>u')

-- Remap for dealing with word wrap
Keymap.normal('k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
Keymap.normal('j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Annihilate semicolons!!! 💀
-- keymap.normal('<leader>;', ":%s/;$//g<cr>'':noh<cr>")

-- Disable highlight till next search
Keymap.normal('<leader>/', ':noh<cr>')

-- Substitute search and replace
Keymap.normal('<C-s>', ':%s/')
Keymap.visual('<C-s>', 'y:%s/\\(<c-r>0\\)')

-- Don't jump to next/prev. Wait for me! At least jump back.
-- this is overriden in nvim-hlslens
Keymap.normal('*', '*N')
Keymap.normal('#', '#N')

-- 3 way diffsplit (merge conflicts)
Keymap.normal('gh', ':diffget //2<cr>')
Keymap.normal('gl', ':diffget //3<cr>')
Keymap.normal('gp', ':diffput //1<cr>')

-- WINDOWS AND TABS --
----------------------
-- Zoom / Fullscreen
Keymap.normal('tt', ':tab split<CR>')

-- split navigations is done by tmux-navigator plugin
-- keymap.normal('<A-h>', '<C-w><C-h>')
-- keymap.normal('<A-j>', '<C-w><C-j>')
-- keymap.normal('<A-k>', '<C-w><C-k>')
-- keymap.normal('<A-l>', '<C-w><C-l>')

-- resize
Keymap.normal('<Up>', ':resize +5<cr>')
Keymap.normal('<Down>', ':resize -5<cr>')

Keymap.normal('<Left>', ':vertical resize -5<cr>')
Keymap.normal('<Right>', ':vertical resize +5<cr>')
