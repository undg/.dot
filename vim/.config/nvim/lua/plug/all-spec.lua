return {
    -- Dependencies
    'nvim-lua/plenary.nvim', -- All the lua functions you don't want to write twice.
    { import = 'plug.icons' },

    -- Productivity
    { import = 'plug.comment' },
    'tpope/vim-sleuth', -- Auto-detect indentation style
    { import = 'plug.nvim-surround' },
    'jiangmiao/auto-pairs',
    { import = 'plug.alpha' },                  -- home screen
    { import = 'plug.neovim-session-manager' }, -- autosave and restore session
    { import = 'plug.suda' },                    -- ask for sudo password
    { import = 'plug.luapad' },                 -- lua scratch pad

    -- Git
    { import = 'plug.lazygit' },
    'tpope/vim-fugitive',         -- Git commands in nvim
    { 'tpope/vim-rhubarb' },      -- Fugitive-companion to interact with github
    { import = 'plug.gitsigns' }, -- Git status for every line
    { 'whiteinge/diffconflicts' },

    -- File managers
    { import = 'plug.neo-tree' },
    { import = 'plug.bufferline' },
    { import = 'plug.telescope' },

    -- LSP
    { 'neovim/nvim-lspconfig' },                     -- Collection of configurations for built-in LSP client
    { 'williamboman/mason.nvim' },                   -- LSP servers installer
    { 'williamboman/mason-lspconfig.nvim' },         -- integration with lspconfig
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' }, -- auto install predefined packages
    { 'jose-elias-alvarez/null-ls.nvim' },           -- inject LSP diagnostics, code actions, and more
    { 'davidmh/cspell.nvim' },                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
    { import = 'plug.lspsaga' },                     -- Improves the Neovim built-in LSP experience.lspsaga.lua
    { import = 'plug.typescript' },                  -- LSP Typescript utils with performant UI
    { import = 'plug.treesitter' },                  -- syntax highlight
    { import = 'plug.trouble' },                     -- organize errors and warnings
    { import = 'plug.autocompletion' },
    'SirVer/ultisnips',                              -- snippets that are integrated with autocompletion nvim-cmp

    -- Registers
    { 'simnalamburt/vim-mundo',          cmd = { 'MundoShow', 'MundoToggle' } },
    { import = 'plug.yanky' },

    -- Utils
    { import = 'plug.vimwiki' },
    { import = 'plug.markdown-preview' },
    { 'godlygeek/tabular',               cmd = { 'Tabularize', 'Tab' } },
    { 'blindFS/vim-colorpicker',         cmd = 'ColorPicker' },
    { import = 'plug.QFEnter' },            -- quickfix window (cw) open in split/tab...
    { import = 'plug.winresizer' },
    { import = 'plug.vimux' },              -- run commands in vimux pane
    { import = 'plug.vim-tmux-navigator' }, -- hybrid tmux, vim window navigation.
    { import = 'plug.which-key' },
    { import = 'plug.lualine' },
    'stevearc/dressing.nvim',

    -- Look and feel
    { import = 'plug.gruvbox' },
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    { import = 'plug.vim-diminactive' },
    { import = 'plug.colorizer' },
    { import = 'plug.illuminate' }, -- automatically highlighting other uses of the word under the cursor
}
