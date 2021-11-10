-- default indentation
vim.opt.autoindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- @TODO rethink it. Take into account scenarios when motions keys are overlaping.
vim.opt.timeout = false
vim.opt.ttimeout = true
-- vim.opt.timeoutlen = 1000
-- vim.opt.ttimeoutlen = 1000

vim.opt.mouse = 'n'

vim.opt.history = 900

-- do not wrap long lines, I'll wrap me myself or prettier will do it.
vim.opt.textwidth = 0
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'min:60,shift:0,sbr'
vim.opt.showbreak = '+++ '
-- @example ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.

-- Don't redraw while executing macros (good performance config)
vim.opt.lazyredraw = true

-- For regular expressions turn magic on
vim.opt.magic = true


-- No annoying sound on errors
vim.opt.errorbells = false
vim.opt.visualbell = false
-- vim.opt.t_vb = ''
vim.opt.tm = 500

vim.opt.encoding = 'utf8'

-- Use Unix as the standard file type
vim.opt.ffs = 'unix,dos,mac'

-- Turn backup off
vim.opt.backup = false
vim.opt.wb = false
vim.opt.swapfile = false

-- auto read when a file is changed from the outside
vim.opt.autoread = true

--Save undo history
vim.opt.undofile = true

-- show white spaces, but only on demand
vim.opt.list = false
vim.opt.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·'

vim.opt.path = vim.opt.path + '**'
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildoptions = 'pum,tagfile'

-- Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

-- Make line numbers default
vim.wo.number = true

-- Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set highlight on search
vim.o.hlsearch = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- vim.opt.clipboard='unnamed,unnamedplus'

-- Highlight on yank
vim.api.nvim_exec(
    [[
    augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
    ]],
    false
)

-- Areas of the screen where the window splits should occur
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 3

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
vim.opt.foldlevel = 9

