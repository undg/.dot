local map = require("utils/map")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- No fcking way! Nope, I don't want ex mode!
map.normal("Q", "<Nop>")
-- Stop that stupid window from popping up!
map.normal("q:", ":q")

-- no need for ESC
map.insert("jk", "<ESC>")

-- align extra maps with ZZ, that is default keybinding for write and quit
-- write only
map.normal("<LEADER><LEADER>", ":write<CR>")
map.normal(",,", ":write<CR>")
-- quit only
map.normal("QQ", ":q<CR>")

-- redo last macro
map.normal("<CR>", "qq")

-- duno... I'm using it a lot.
map.normal("<LEADER>s", ":mksession!<CR>", { silent = false })
-- cd to current file path
map.normal("<LEADER>cd", ":lcd %:p:h<CR>")

-- remove white spaces on end line
map.normal("<LEADER>sp", ':%s/\\s\\+$//ge<CR>:echomsg "white space cleaing"<cr>')

-- Toggle list (display unprintable characters).
map.normal("<F8>", ":set list!<CR>")
map.insert("<F8>", "<esc>:set list!<CR>i")

-- get git branch go into insert mode.
-- map.normal('<leader>gb', ':0r!git rev-parse --abbrev-ref HEAD<CR>A:<SPACE>')
map.normal("<leader>gb", ':0r! git rev-parse --abbrev-ref HEAD | awk -F "-" "{print \\$1 \\"-\\" \\$2 \\": \\"}" <CR>A')

-- indent, highlight in visual stay
map.visual(">", ">gv")
map.visual("<", "<gv")

-- ts/sw 2<-->4 toggle indentation
map.normal("<c-_>", ":ToggleIndent<cr>", { silent = false })

-- Yanking/Pasting
-- map.normal('<leader>p', '"+p')
map.visual("<C-C>", '"+y')
map.insert("<C-v>", '<c-o>"+p')
map.visual("<C-v>", 'd"+p')
-- Y yank until the end of line  (note: this is now a default on master)
map.normal("Y", "y$")
-- Only visual, keep same yank in register
map.visual("<LEADER>p", '"_dP')

-- Keep it in center
map.normal("n", "nzz")
map.normal("N", "Nzz")
map.normal("''", "''zz")

map.visual("n", "nzzzv")
map.visual("N", "Nzzzv")
map.visual("''", "''zzzv")

map.normal("J", "mzJ`z")
map.normal("<C-n>", ":cnext<CR>zzzv")
map.normal("<C-p>", ":cprev<CR>zzzv")

-- Extra break points
map.insert(",", ",<C-g>u")
map.insert(".", ".<C-g>u")
map.insert("!", "!<C-g>u")
map.insert("?", "?<C-g>u")

-- Remap for dealing with word wrap
map.normal("k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map.normal("j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Annihilate semicolons!!! 💀
-- map.normal("<leader>;", ":%s/;$//g<cr>''")

-- Disable highlight till next search
map.normal("<leader>/", ":noh<cr>")

-- Don't jump to next/prev. Wait for me! At least jump back.
-- this is overriden in nvim-hlslens
-- map.normal("*", "*N")
-- map.normal("#", "#N")
