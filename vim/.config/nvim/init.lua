require("utils.globals")

-- Make sure to set `mapleader` before lazy so your mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("plugins")
require("start-lazy")

require("custom.formater")
require("custom.indent-toggle")
require("custom.conceal-toggle")
require("custom.json2ts")
require("custom.search-selected")
require("custom.ultisnip-functions")
require("custom.pum-completion-up-down")
require("custom.hover-fix") -- @TODO (undg) 2024-03-20: Check it once a while and try to delete fix. Doc inside file.
require("custom.highlight")

require("lsp")

require("config")

require("keymap")

require("autocmd")
