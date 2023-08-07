return {
    -- Dependencies
    'nvim-lua/plenary.nvim', -- All the lua functions you don't want to write twice.
    { import = 'plugin.icons' },

    -- Productivity
    { import = 'plugin.comment' },
    'tpope/vim-sleuth', -- Auto-detect indentation style
    { import = 'plugin.nvim-surround' },
    'jiangmiao/auto-pairs',
    { import = 'plugin.alpha' },                  -- home screen
    { import = 'plugin.neovim-session-manager' }, -- autosave and restore session
    { import = 'plugin.suda' },                   -- ask for sudo password
    { import = 'plugin.luapad' },                 -- lua scratch pad

    -- Git
    { import = 'plugin.lazygit' },
    'tpope/vim-fugitive',         -- Git commands in nvim
    { 'tpope/vim-rhubarb' },      -- Fugitive-companion to interact with github
    { import = 'plugin.gitsigns' }, -- Git status for every line
    { 'whiteinge/diffconflicts' },

    -- File managers
    { import = 'plugin.neo-tree' },
    { import = 'plugin.bufferline' },
    { import = 'plugin.telescope' },
    { import = 'plugin.harpoon' },

    -- LSP
    { 'neovim/nvim-lspconfig' },                     -- Collection of configurations for built-in LSP client
    { 'williamboman/mason.nvim' },                   -- LSP servers installer
    { 'williamboman/mason-lspconfig.nvim' },         -- integration with lspconfig
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' }, -- auto install predefined packages
    { 'jose-elias-alvarez/null-ls.nvim' },           -- inject LSP diagnostics, code actions, and more
    { 'davidmh/cspell.nvim' },                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
    { import = 'plugin.lspsaga' },                     -- Improves the Neovim built-in LSP experience.lspsaga.lua
    { import = 'plugin.typescript' },                  -- LSP Typescript utils with performant UI
    { import = 'plugin.treesitter' },                  -- syntax highlight
    { import = 'plugin.trouble' },                     -- organize errors and warnings
    { import = 'plugin.autocompletion' },
    'SirVer/ultisnips',                              -- snippets that are integrated with autocompletion nvim-cmp

    -- Registers
    { 'simnalamburt/vim-mundo',          cmd = { 'MundoShow', 'MundoToggle' } },
    { import = 'plugin.yanky' },

    -- Utils
    { import = 'plugin.vimwiki' },
    { import = 'plugin.markdown-preview' },
    { 'godlygeek/tabular',               cmd = { 'Tabularize', 'Tab' } },
    { 'blindFS/vim-colorpicker',         cmd = 'ColorPicker' },
    { import = 'plugin.qfenter' },            -- quickfix window (cw) open in split/tab...
    { import = 'plugin.winresizer' },
    { import = 'plugin.vimux' },              -- run commands in vimux pane
    { import = 'plugin.vim-tmux-navigator' }, -- hybrid tmux, vim window navigation.
    { import = 'plugin.which-key' },
    { import = 'plugin.lualine' },
    'stevearc/dressing.nvim',

    -- Look and feel
    { import = 'plugin.gruvbox' },
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    { import = 'plugin.vim-diminactive' },
    { import = 'plugin.colorizer' },
    { import = 'plugin.illuminate' }, -- automatically highlighting other uses of the word under the cursor
}
