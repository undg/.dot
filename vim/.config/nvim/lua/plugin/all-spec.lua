return {
    -- Dependencies
    'nvim-lua/plenary.nvim',     -- All the lua functions you don't want to write twice.
    { import = 'plugin.icons' }, -- icons used by few plugins

    -- Productivity
    { import = 'plugin.comment' },                -- commenting code
    { import = 'plugin.nvim-surround' },          -- surround selection with brackets, quotes etc.
    { import = 'plugin.alpha' },                  -- home screen
    { import = 'plugin.neovim-session-manager' }, -- autosave and restore session
    { import = 'plugin.suda' },                   -- ask for sudo password
    { import = 'plugin.luapad' },                 -- lua scratch pad
    { 'tpope/vim-sleuth' },                       -- Auto-detect indentation style
    { 'jiangmiao/auto-pairs' },                   -- auto closing brackets, quotes etc.

    -- Git
    { import = 'plugin.lazygit' },  -- open lazygit in floating window. Lazygit need to be installed in system
    { import = 'plugin.gitsigns' }, -- Git status for every line
    { 'tpope/vim-fugitive' },       -- Git commands in nvim
    { 'tpope/vim-rhubarb' },        -- Fugitive-companion to interact with github
    { 'whiteinge/diffconflicts' },  -- Call :DiffConflicts to convert a file containing conflict markers into a two-way diff.

    -- File managers
    { import = 'plugin.neo-tree' },
    { import = 'plugin.bufferline' },
    { import = 'plugin.telescope' },
    { import = 'plugin.harpoon' },

    -- LSP, code and linting
    { import = 'plugin.lspsaga' },                   -- Improves the Neovim built-in LSP experience.lspsaga.lua
    { import = 'plugin.typescript' },                -- LSP Typescript utils with performant UI
    { import = 'plugin.treesitter' },                -- syntax highlight
    { import = 'plugin.trouble' },                   -- organize errors and warnings
    { import = 'plugin.autocompletion' },            -- collection of plugins related with autocompletion
    { 'neovim/nvim-lspconfig' },                     -- Collection of configurations for built-in LSP client
    { 'williamboman/mason.nvim' },                   -- LSP servers installer
    { 'williamboman/mason-lspconfig.nvim' },         -- integration with lspconfig
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' }, -- auto install predefined packages
    { 'jose-elias-alvarez/null-ls.nvim' },           -- inject LSP diagnostics, code actions, and more
    { 'davidmh/cspell.nvim' },                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
    { 'SirVer/ultisnips' },                          -- snippets that are integrated with autocompletion nvim-cmp

    -- Registers
    { import = 'plugin.yanky' },
    { 'simnalamburt/vim-mundo',                   cmd = { 'MundoShow', 'MundoToggle' } },

    -- Utils
    { import = 'plugin.vimwiki' },
    { import = 'plugin.markdown-preview' },
    { import = 'plugin.qfenter' },                          -- quickfix window (cw) open in split/tab...
    { import = 'plugin.winresizer' },                       -- easy resize windows
    { import = 'plugin.vimux' },                            -- run commands in vimux pane
    { import = 'plugin.vim-tmux-navigator' },               -- hybrid tmux, vim window navigation.
    { import = 'plugin.which-key' },                        -- display interactive footer with available keymaps
    { import = 'plugin.lualine' },                          -- status bar with few informations
    { 'godlygeek/tabular',                        cmd = { 'Tabularize', 'Tab' } }, -- align text in colums in table style.
    { 'blindFS/vim-colorpicker',                  cmd = 'ColorPicker' }, -- open xorg window with color picker
    { 'stevearc/dressing.nvim' },                           -- better floating window styles

    -- Look and feel
    { import = 'plugin.gruvbox' },             -- best theme on the universe
    { import = 'plugin.vim-diminactive' },     -- dim inactive window
    { import = 'plugin.colorizer' },           -- paint hex values with color
    { import = 'plugin.illuminate' },          -- automatically highlighting other uses of the word under the cursor
    { 'lukas-reineke/indent-blankline.nvim' }, -- Add indentation guides even on blank lines
}
