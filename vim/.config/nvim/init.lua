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
require("custom.lsp-actions-checker")
require("custom.highlight")
require("custom.git-files")
require("custom.only-global-marks")
require("custom.buf-prefix-selected")

require("lsp")

require("config")

require("keymap.general") -- always first
require("keymap.lsp")
require("keymap.spell")
require("keymap.typescript-nvim")
require("keymap.tabular")
require("keymap.fugitive")
require("keymap.spell-autofixer")

require("autocmd")
