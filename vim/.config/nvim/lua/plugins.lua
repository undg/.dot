-- Dependencies
Spec("plugins.icons")                           -- icons used by few plugins
Git("https://github.com/nvim-lua/plenary.nvim") -- All the lua functions you don't want to write twice.

-- Productivity
Spec("plugins.comment")                -- commenting code
Spec("plugins.mini-surround")          -- surround selection with brackets, quotes etc.
-- Spec('plugins.nvim-autopairs')             -- auto closing brackets, quotes etc.
Spec("plugins.alpha")                  -- home screen
Spec("plugins.neovim-session-manager") -- autosave and restore session
Spec("plugins.suda")                   -- ask for sudo password
Spec("plugins.luapad")                 -- lua scratch pad
-- Git('https://github.com/tpope/vim-sleuth') -- Auto-detect indentation style
Spec("plugins.bigfile")                -- lighter config for big files
Spec("plugins.todo-comments")          -- highlight and search TODO comments

-- Git
Spec("plugins.lazygit")  -- open lazygit in floating window. Lazygit need to be installed in system
Spec("plugins.gitsigns") -- Git status for every line
Spec("plugins.git-conflict")
-- Spec('plugins.neogit')                            -- A Magit clone for Neovim
-- Spec('plugins.octo-nvim')
Git("https://github.com/tpope/vim-fugitive")      -- Git commands in nvim
Git("https://github.com/tpope/vim-rhubarb")       -- Fugitive-companion to interact with github
Git("https://github.com/whiteinge/diffconflicts") -- Call :DiffConflicts to convert a file containing conflict markers into a two-way diff.

-- File managers
Spec("plugins.telescope")                -- Swiss knife
Spec("plugins.neo-tree")                 -- file manager
Spec("plugins.oil-nvim")                 -- file manager
Spec("plugins.harpoon")                  -- bookmark like buffer storage
Spec("plugins.nvim-lsp-file-operations") -- adds support for file operations using built-in LSP (update imports)

-- LSP, code and linting
Spec("plugins.lspsaga")                          -- Improves the Neovim built-in LSP experience.lspsaga.lua
Spec("plugins.typescript")                       -- LSP Typescript utils with performant UI
Spec("plugins.golang")                           -- LSP golang utils with performant UI
Spec("plugins.treesitter")                       -- syntax highlight
Spec("plugins.conform")                          -- better formatting
Spec("plugins.trouble")                          -- organize errors and warnings
Spec("plugins.nvim-cmp")                         -- collection of plugins related with autocompletion
Spec("plugins.mason")
Spec("plugins.overseer-nvim")                    -- A task runner and job management plugin for Neovim
Git("https://github.com/cseickel/diagnostic-window.nvim")
Git("https://github.com/folke/neodev.nvim")      -- Neovim full signature help, docs and completion for the nvim lua API.
Git("https://github.com/neovim/nvim-lspconfig")  -- Collection of configurations for built-in LSP client
Git("https://github.com/nvimtools/none-ls.nvim") -- inject LSP diagnostics, code actions, and more
Git("https://github.com/SirVer/ultisnips")       -- snippets that are integrated with autocompletion nvim-cmp

-- -- Testing
-- -- @TODO (undg) 2024-12-10: IT'S PROMISING, but underdeveloped. Need DAP and a bit of work.
-- Spec('plugins.neotest') -- running tests

-- Debugging
Git("https://github.com/pappasam/nvim-repl")
-- (DAP)
-- Git('https://github.com/fussenegger/nvim-dap')
-- Git('https://github.com/eoluz/nvim-dap-go')
-- Git('https://github.com/carriga/nvim-dap-ui')
-- Git('https://github.com/heHamsta/nvim-dap-virtual-text')
-- Git('https://github.com/vim-telescope/telescope-dap.nvim')

-- Registers
Spec("plugins.yanky")
Spec("plugins.vim-mundo")

-- Utils
Spec("plugins.obsidian")                         -- Note taking and knowledge base
Spec("plugins.markdown-preview")                 -- Preview Markdown in your modern browser with synchronised scrolling
Spec("plugins.render-markdown-nvim")             -- render markdown in vim editor
Spec("plugins.gp-nvim")                          -- AI chat interface for popular LLM's with API
-- Spec("plugins.avante")                           -- AI code assistance, Cursor emulator
Spec("plugins.qfenter")                          -- quickfix window (cw) open in split/tab...
Spec("plugins.vimux")                            -- run commands in vimux pane
Spec("plugins.nvim-tmux-navigation")             -- hybrid tmux, vim window navigation.
Spec("plugins.tabular")                          -- align text in column in table style.
Spec("plugins.marks")                            -- better marks management
Spec("plugins.streamer-mode")                    -- hide shell local variables
Git("https://github.com/stevearc/dressing.nvim") -- better floating window styles
Git("https://github.com/milisims/nvim-luaref")   -- adds a reference for builtin lua functions

-- Look and feel
Spec("plugins.theme")                 -- gruvbox is best theme on the universe
Spec("plugins.lualine")               -- status bar with few informations
Spec("plugins.bufferline")
Spec("plugins.nvim-navic")            -- Breadcrumbs
Spec("plugins.which-key")             -- display interactive footer with available keymaps
-- Spec('plugins.vim-diminactive')       -- dim inactive window
Spec("plugins.colorizer")             -- paint hex values with color
Spec("plugins.illuminate")            -- automatically highlighting other uses of the word under the cursor
Spec("plugins.windows-nvim")          -- Automatically manage size of current window;
Spec("plugins.indent-blankline-nvim") -- Add indentation guides even on blank lines in fold
Spec("plugins.nvim-ufo")
Spec("plugins.notification")          -- Show one or more highlighted notifications in a single floating window.
