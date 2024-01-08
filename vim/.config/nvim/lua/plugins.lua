-- Dependencies
Spec('plugins.icons')                           -- icons used by few plugins
Git('https://github.com/nvim-lua/plenary.nvim') -- All the lua functions you don't want to write twice.

-- Productivity
Spec('plugins.comment')                        -- commenting code
Spec('plugins.nvim-surround')                  -- surround selection with brackets, quotes etc.
Spec('plugins.alpha')                          -- home screen
Spec('plugins.neovim-session-manager')         -- autosave and restore session
Spec('plugins.suda')                           -- ask for sudo password
Spec('plugins.luapad')                         -- lua scratch pad
Git('https://github.com/tpope/vim-sleuth')     -- Auto-detect indentation style
Git('https://github.com/jiangmiao/auto-pairs') -- auto closing brackets, quotes etc.

-- Git
Spec('plugins.lazygit')                           -- open lazygit in floating window. Lazygit need to be installed in system
Spec('plugins.gitsigns')                          -- Git status for every line
Spec('plugins.neogit')                            -- A Magit clone for Neovim
Git('https://github.com/tpope/vim-fugitive')      -- Git commands in nvim
Git('https://github.com/tpope/vim-rhubarb')       -- Fugitive-companion to interact with github
Git('https://github.com/whiteinge/diffconflicts') -- Call :DiffConflicts to convert a file containing conflict markers into a two-way diff.

-- File managers
Spec('plugins.neo-tree')
Spec('plugins.bufferline')
Spec('plugins.telescope')
Spec('plugins.harpoon')

-- LSP, code and linting
Spec('plugins.lspsaga')                                             -- Improves the Neovim built-in LSP experience.lspsaga.lua
Spec('plugins.typescript')                                          -- LSP Typescript utils with performant UI
Spec('plugins.golang')                                              -- LSP golang utils with performant UI
Spec('plugins.treesitter')                                          -- syntax highlight
Spec('plugins.trouble')                                             -- organize errors and warnings
Spec('plugins.nvim-cmp')                                            -- collection of plugins related with autocompletion
Git('https://github.com/folke/neodev.nvim')                         -- Neovim full signature help, docs and completion for the nvim lua API.
Git('https://github.com/neovim/nvim-lspconfig')                     -- Collection of configurations for built-in LSP client
Git('https://github.com/williamboman/mason.nvim')                   -- LSP servers installer
Git('https://github.com/williamboman/mason-lspconfig.nvim')         -- integration with lspconfig
Git('https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim') -- auto install predefined packages
Git('https://github.com/nvimtools/none-ls.nvim')                    -- inject LSP diagnostics, code actions, and more
Git('https://github.com/davidmh/cspell.nvim')                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
Git('https://github.com/SirVer/ultisnips')                          -- snippets that are integrated with autocompletion nvim-cmp

-- Registers
Spec('plugins.yanky')
Spec('plugins.vim-mundo')

-- AI
Spec('plugins.sg')      -- LLM Cody chat and Sourcegraph AI code search engine. sourcegraph.com
Spec('plugins.codeium') -- LLM codeium is AI powered code completion. codeium.com
Spec('plugins.gp-nvim') -- LLM chatGPT is AI powered code completion and chat bot. https://platform.openai.com/

-- Utils
-- @TODO (undg) 2024-01-08: think about replacement
Spec('plugins.vimwiki')
Spec('plugins.markdown-preview')                 -- Preview Markdown in your modern browser with synchronised scrolling
Spec('plugins.qfenter')                          -- quickfix window (cw) open in split/tab...
Spec('plugins.vimux')                            -- run commands in vimux pane
Spec('plugins.nvim-tmux-navigation')             -- hybrid tmux, vim window navigation.
Spec('plugins.which-key')                        -- display interactive footer with available keymaps
Spec('plugins.lualine')                          -- status bar with few informations
Spec('plugins.tabular')                          -- align text in colums in table style.
Spec('plugins.vim-colorpicker')                  -- open xorg window with color picker
Git('https://github.com/stevearc/dressing.nvim') -- better floating window styles

-- Look and feel
Spec('plugins.theme')                                         -- gruvbox is best theme on the universe
Spec('plugins.vim-diminactive')                               -- dim inactive window
Spec('plugins.colorizer')                                     -- paint hex values with color
Spec('plugins.illuminate')                                    -- automatically highlighting other uses of the word under the cursor
Spec('plugins.fidget')                                        -- LSP notification
Spec('plugins.noice')                                         -- notification
Git('https://github.com/lukas-reineke/indent-blankline.nvim') -- Add indentation guides even on blank lines

