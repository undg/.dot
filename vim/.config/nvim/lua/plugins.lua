-- Dependencies
Spec('spec.icons')           -- icons used by few plugins
Git('nvim-lua/plenary.nvim') -- All the lua functions you don't want to write twice.

-- Productivity
Spec('spec.comment')                -- commenting code
Spec('spec.nvim-surround')          -- surround selection with brackets, quotes etc.
Spec('spec.alpha')                  -- home screen
Spec('spec.neovim-session-manager') -- autosave and restore session
Spec('spec.suda')                   -- ask for sudo password
Spec('spec.luapad')                 -- lua scratch pad
Git('tpope/vim-sleuth')             -- Auto-detect indentation style
Git('jiangmiao/auto-pairs')         -- auto closing brackets, quotes etc.

-- Git
Spec('spec.lazygit')           -- open lazygit in floating window. Lazygit need to be installed in system
Spec('spec.gitsigns')          -- Git status for every line
Spec('spec.neogit')            -- A Magit clone for Neovim
Git('tpope/vim-fugitive')      -- Git commands in nvim
Git('tpope/vim-rhubarb')       -- Fugitive-companion to interact with github
Git('whiteinge/diffconflicts') -- Call :DiffConflicts to convert a file containing conflict markers into a two-way diff.

-- File managers
Spec('spec.neo-tree')
Spec('spec.bufferline')
Spec('spec.telescope')
Spec('spec.harpoon')

-- LSP, code and linting
Spec('spec.lspsaga')                             -- Improves the Neovim built-in LSP experience.lspsaga.lua
Spec('spec.typescript')                          -- LSP Typescript utils with performant UI
Spec('spec.golang')                              -- LSP golang utils with performant UI
Git('folke/neodev.nvim')                         -- Neovim full signature help, docs and completion for the nvim lua API.
Spec('spec.treesitter')                          -- syntax highlight
Spec('spec.trouble')                             -- organize errors and warnings
Spec('spec.nvim-cmp')                            -- collection of plugins related with autocompletion
Git('neovim/nvim-lspconfig')                     -- Collection of configurations for built-in LSP client
Git('williamboman/mason.nvim')                   -- LSP servers installer
Git('williamboman/mason-lspconfig.nvim')         -- integration with lspconfig
Git('WhoIsSethDaniel/mason-tool-installer.nvim') -- auto install predefined packages
Git('nvimtools/none-ls.nvim')                    -- inject LSP diagnostics, code actions, and more
Git('davidmh/cspell.nvim')                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
Git('SirVer/ultisnips')                          -- snippets that are integrated with autocompletion nvim-cmp

-- Registers
Spec('spec.yanky')
Spec('spec.vim-mundo')

-- AI
Spec('spec.sg')      -- LLM Cody chat and Sourcegraph AI code search engine. sourcegraph.com
Spec('spec.codeium') -- LLM codeium is AI powered code completion. codeium.com
Spec('spec.gp-nvim') -- LLM chatGPT is AI powered code completion and chat bot. https://platform.openai.com/

-- Utils
Spec('spec.vimwiki')
Spec('spec.markdown-preview')
Spec('spec.qfenter')            -- quickfix window (cw) open in split/tab...
Spec('spec.vimux')              -- run commands in vimux pane
Spec('spec.vim-tmux-navigator') -- hybrid tmux, vim window navigation.
Spec('spec.which-key')          -- display interactive footer with available keymaps
Spec('spec.lualine')            -- status bar with few informations
Spec('spec.tabular')            -- align text in colums in table style.
Spec('spec.vim-colorpicker')    -- open xorg window with color picker
Git('stevearc/dressing.nvim')   -- better floating window styles

-- Look and feel
Spec('spec.theme')                         -- gruvbox is best theme on the universe
Spec('spec.vim-diminactive')               -- dim inactive window
Spec('spec.colorizer')                     -- paint hex values with color
Spec('spec.illuminate')                    -- automatically highlighting other uses of the word under the cursor
Git('lukas-reineke/indent-blankline.nvim') -- Add indentation guides even on blank lines
Spec('spec.illuminate')                    -- automatically highlighting other uses of the word under the cursor }
Spec('spec.fidget')                        -- notification
