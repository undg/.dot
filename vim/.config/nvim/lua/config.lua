vim.opt.encoding = "utf8"                                                      -- set encoding
vim.opt.ffs = "unix,dos,mac"                                                   -- Use Unix as the standard file type


vim.opt.mouse = "n"                                                            -- mouse only in normal mode
vim.o.updatetime = 250                                                         -- Decrease update time

vim.opt.timeout = false                                                        -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received.
vim.opt.timeoutlen = 500                                                       -- wait that long for motion sequence to end
vim.opt.ttimeout = true                                                        -- This option and 'ttimeoutlen' determine the behavior when part of a key code sequence has been received by the |TUI|.

vim.opt.backup = false                                                         -- Turn off backup
vim.opt.writebackup = false                                                    -- Turn off writebackup
vim.opt.swapfile = false                                                       -- Turn off swapfile
vim.o.hidden = true                                                            -- Do not save when switching buffers
vim.opt.autoread = true                                                        -- Auto reload file when changed from the outside
vim.opt.undofile = true                                                        -- Save undo history

                                                                               -- wildmenu (command-line)
vim.opt.wildmenu = true                                                        -- autocompletion on
vim.opt.wildmode = "longest:full,full"                                         -- style
vim.opt.wildoptions = "pum,tagfile"                                            -- options
vim.o.inccommand = "nosplit"                                                   -- Incremental live completion
vim.opt.history = 900                                                          -- The command-line history table size.
vim.opt.path = vim.opt.path + "**"                                             -- Help with searching via :find and :grep (I'm using 3rd party for that anyway)

                                                                               -- don't report in :checkhealth
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

                                                                               -- Searching
vim.opt.magic = true                                                           -- For regular expressions turn magic on
vim.o.hlsearch = true                                                          -- highlight
vim.o.ignorecase = true                                                        -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true                                                         -- Case insensitive searching UNLESS /C or capital in search

                                                                               -- Look and feel
vim.opt.splitbelow = true                                                      -- Areas of the screen where the window splits should occur
vim.opt.splitright = true                                                      -- Areas of the screen where the window splits should occur
vim.opt.scrolloff = 3                                                          -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.cursorline = true                                                      -- highlight current line
vim.wo.signcolumn = "yes"                                                      -- always show area left from line numbers ,@TODO (undg) 2022-12-25: fit here more informations. gitsign, marks, dap...
vim.wo.number = true                                                           -- Make line numbers default ,this is overridden in auto command with hybrid line number
vim.opt.lazyredraw = true                                                      -- Don't redraw while executing macros (good performance config)
vim.opt.errorbells = false                                                     -- No annoying sound on errors
vim.opt.visualbell = false                                                     -- No annoying sound on errors
vim.opt.termguicolors = true                                                   -- enable highlight groups

                                                                               -- show white spaces, but only on demand
vim.opt.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·"
vim.opt.list = false

                                                                               -- default indentation (there is plugin that's trying to guess indentation style in opened file)
vim.opt.autoindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

                                                                               -- folding
vim.opt.foldmethod = "indent"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 9

                                                                               -- DON'T WRAP LONG LINES! I'll wrap them with formatter or by myself.
vim.opt.textwidth = 0
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "min:60,shift:0,sbr"
vim.opt.showbreak = "+++ "                                                     -- show that sign on breaked lines.
                                                                               -- @example ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.  ...and if they need to be long, just display them with line break.
