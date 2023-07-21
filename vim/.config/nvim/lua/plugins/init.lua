local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to set `mapleader` before lazy so your mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


require('lazy').setup({
    -- Dependencies
    'nvim-lua/plenary.nvim',       -- All the lua functions you don't want to write twice.
    'onsails/lspkind-nvim',        -- icons for lsp
    {
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        config = function()
            require('plugins.nvim-web-devicons')
        end,
    }, -- icons for telescope and Neotree and all sorts of plugins

    -- Productivity
    {
        'numToStr/Comment.nvim',
        config = function()
            require('plugins.Comment')
        end,
    },
    'tpope/vim-sleuth', -- Auto-detect indentation style
    {
        'kylechui/nvim-surround',
        version = '*', -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require('plugins.nvim-surround')
        end,
    },
    'jiangmiao/auto-pairs',
    {
        'folke/trouble.nvim',
        config = function()
            require('plugins.trouble')
        end,
    },
    {
        'goolord/alpha-nvim',
        config = function()
            require('plugins.alpha')
        end,
    },
    { 'nvim-telescope/telescope-project.nvim' }, -- quick access to saved projects paths.
    {
        'Shatur/neovim-session-manager',
        config = function()
            require('plugins.neovim-session-manager')
        end,
    },
    {
        'phaazon/hop.nvim',
        config = function()
            require('plugins.hop')
        end,
    },
    {
        'lambdalisue/suda.vim',
        config = function()
            require('plugins.suda')
        end,
    }, -- ask for sudo password
    {
        'rafcamlet/nvim-luapad',
        config = function()
            require('plugins.luapad')
        end,
    }, -- lua scratch pad

    -- Git
    {
        'kdheepak/lazygit.nvim',
        config = function()
            require('plugins.lazygit')
        end,
    },
    'tpope/vim-fugitive',      -- Git commands in nvim
    { 'tpope/vim-rhubarb' },   -- Fugitive-companion to interact with github
    {
        'lewis6991/gitsigns.nvim', -- Git status for every line
        config = function()
            require('plugins.gitsigns')
        end,
    },
    {
        'whiteinge/diffconflicts',
        -- config = function()
        -- require('plugins.diffconflicts')
        -- end,
    },

    -- File managers
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require('plugins.neo-tree')
        end,
    },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        config = function()
            require('plugins.bufferline') -- "tabline" for buffers.
        end,
        dependencies = {
            { 'moll/vim-bbye' }, -- :Bdelete and :Bwipeout to preserve window layout
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim',  build = 'make' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            {
                'ThePrimeagen/harpoon',
                config = function()
                    require('plugins.harpoon')
                end,
            },
        },
        config = function()
            require('plugins.telescope')
        end,
    },

    -- LSP
    { 'neovim/nvim-lspconfig' },                     -- Collection of configurations for built-in LSP client
    { 'williamboman/mason.nvim' },                   -- LSP servers installer
    { 'williamboman/mason-lspconfig.nvim' },         -- integration with lspconfig
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' }, -- auto install predefined packages
    { 'jose-elias-alvarez/null-ls.nvim' },           -- inject LSP diagnostics, code actions, and more
    { 'davidmh/cspell.nvim' },                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('plugins.lspsaga')
        end,
    },                                        -- LSP utils with performant UI
    'jose-elias-alvarez/typescript.nvim', -- few extra commands for ts. Uses LSP
    {
        'marilari88/twoslash-queries.nvim',
        config = function()
            require('plugins.twoslash-queries')
        end,
    }, -- // live type checking with //  ^?

    -- Syntax
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('plugins.treesitter')
        end,
    },                                                 -- Highlight, edit, and navigate code using a fast incremental parsing library
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects for treesitter
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        config = function()
            require('plugins.nvim-cmp')
        end,
    },
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    -- snippets are integrated with autocompletion nvim-cmp
    'SirVer/ultisnips',
    'quangnguyen30192/cmp-nvim-ultisnips',

    -- Registers
    { 'simnalamburt/vim-mundo', cmd = { 'MundoShow', 'MundoToggle' } },
    {
        'gbprod/yanky.nvim',
        config = function()
            require('plugins.yanky')
        end,
    },

    -- Utils
    {
        'vimwiki/vimwiki',
        config = function()
            require('plugins.vimwiki')
        end,
    },
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install',
        setup = function()
            -- you need yarn or npm already installed in os
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },
    {
        'godlygeek/tabular',
        cmd = { 'Tabularize', 'Tab' },
    },
    { 'blindFS/vim-colorpicker', cmd = 'ColorPicker' },
    {
        'benmills/vimux', -- build comand(test) in split tmux pane
        config = function()
            require('plugins.vimux')
        end,
    },
    {
        'yssl/QFEnter', -- quickfix window (cw) open in split/tab...
        config = function()
            require('plugins.QFEnter')
        end,
    },
    {
        'simeji/winresizer',
        config = function()
            require('plugins.winresizer')
        end,
    },
    {
        'christoomey/vim-tmux-navigator',
        config = function()
            require('plugins.vim-tmux-navigator')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('plugins.lualine') -- "tabline" for buffers.
        end,
    },
    {
        'folke/which-key.nvim',
        config = function()
            require('plugins.which-key')
        end,
    },
    'stevearc/dressing.nvim',

    -- Look and feel
    {
        'morhetz/gruvbox',
        config = function()
            require('theme')
        end,
    },
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    {
        'blueyed/vim-diminactive',
        config = function()
            require('plugins.vim-diminactive')
        end,
    },
    {
        'lilydjwg/colorizer',
        config = function()
            require('plugins.colorizer')
        end,
        cmd = { 'ColorHighlight', 'ColorToggle' },
    },
    {
        'RRethy/vim-illuminate', -- automatically highlighting other uses of the word under the cursor
        config = function()
            require('plugins.illuminate')
        end,
    },
})
