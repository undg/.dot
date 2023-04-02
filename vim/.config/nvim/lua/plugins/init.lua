local bootstraping = PACKER_BOOTSTRAPING -- globals.lua

local packer_ok, packer = pcall(require, 'packer')
if not packer_ok then
    print('plugins/init.lua: missing requirements')
    return
end

packer.startup(function(use)
    -- Core
    use('wbthomason/packer.nvim') -- This plugin manager

    -- Dependencies
    use('nvim-lua/plenary.nvim')       -- All the lua functions you don't want to write twice.
    use('onsails/lspkind-nvim')        -- icons for lsp
    use({
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        config = function()
            require('plugins.nvim-web-devicons')
        end,
    }) -- icons for telescope and Neotree and all sorts of plugins

    -- Productivity
    use({
        'numToStr/Comment.nvim',
        config = function()
            require('plugins.Comment')
        end,
    })
    use('tpope/vim-sleuth') -- Auto-detect indentation style
    use({
        'kylechui/nvim-surround',
        tag = '*', -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require('plugins.nvim-surround')
        end,
    })
    use('jiangmiao/auto-pairs')
    use({
        'folke/trouble.nvim',
        config = function()
            require('plugins.trouble')
        end,
    })
    use({
        'goolord/alpha-nvim',
        config = function()
            require('plugins.alpha')
        end,
    })
    use({ 'nvim-telescope/telescope-project.nvim' }) -- quick access to saved projects paths.
    use({
        'Shatur/neovim-session-manager',
        config = function()
            require('plugins.neovim-session-manager')
        end,
    })
    use({
        'phaazon/hop.nvim',
        config = function()
            require('plugins.hop')
        end,
    })
    use({
        'lambdalisue/suda.vim',
        config = function()
            require('plugins.suda')
        end,
    }) -- ask for sudo password
    use({
        'rafcamlet/nvim-luapad',
        config = function()
            require('plugins.luapad')
        end,
    }) -- lua scratch pad
    use({
        'iamcco/markdown-preview.nvim',
        run = 'cd app && npm install',
        setup = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    })

    -- Git
    use({
        'kdheepak/lazygit.nvim',
        config = function()
            require('plugins.lazygit')
        end,
    })
    use('tpope/vim-fugitive')      -- Git commands in nvim
    use({ 'tpope/vim-rhubarb' })   -- Fugitive-companion to interact with github
    use({
        'lewis6991/gitsigns.nvim', -- Git status for every line
        config = function()
            require('plugins.gitsigns')
        end,
    })

    -- File managers
    use({
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        requires = {
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require('plugins.neo-tree')
        end,
    })
    use({
        'akinsho/bufferline.nvim',
        tag = 'v3.*',
        config = function()
            require('plugins.bufferline') -- "tabline" for buffers.
        end,
        requires = {
            { 'moll/vim-bbye' }, -- :Bdelete and :Bwipeout to preserve window layout
        },
    })
    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim',  run = 'make' },
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
    })

    -- LSP
    use({ 'neovim/nvim-lspconfig' })                     -- Collection of configurations for built-in LSP client
    use({ 'williamboman/mason.nvim' })                   -- LSP servers installer
    use({ 'williamboman/mason-lspconfig.nvim' })         -- integration with lspconfig
    use({ 'WhoIsSethDaniel/mason-tool-installer.nvim' }) -- auto install predefined packages
    use({ 'jose-elias-alvarez/null-ls.nvim' })           -- inject LSP diagnostics, code actions, and more
    use({
        'tami5/lspsaga.nvim',
        config = function()
            require('plugins.lspsaga')
        end,
    })                                        -- LSP utils with performant UI
    use('jose-elias-alvarez/typescript.nvim') -- few extra commands for ts. Uses LSP
    use({
        'marilari88/twoslash-queries.nvim',
        config = function()
            require('twoslash-queries').setup({
                multi_line = true,  -- to print types in multi line mode
                is_enabled = true,  -- to keep disabled at startup and enable it on request with the EnableTwoslashQueries
                highlight = 'Type', -- to set up a highlight group for the virtual text
            })
        end,
    }) -- // live type checking with ?^

    -- Syntax
    use({
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('plugins.treesitter')
        end,
    })                                                 -- Highlight, edit, and navigate code using a fast incremental parsing library
    use('nvim-treesitter/nvim-treesitter-textobjects') -- Additional text objects for treesitter
    use('p00f/nvim-ts-rainbow')                        -- parenthesis rainbow, treesitter version

    -- Autocompletion
    use({
        'hrsh7th/nvim-cmp',
        config = function()
            require('plugins.nvim-cmp')
        end,
    })
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-nvim-lua')
    use('hrsh7th/cmp-nvim-lsp')
    -- snippets are integrated with autocompletion nvim-cmp
    use('SirVer/ultisnips')
    use('quangnguyen30192/cmp-nvim-ultisnips')

    -- Registers
    use({ 'simnalamburt/vim-mundo', cmd = { 'MundoShow', 'MundoToggle' } })
    use({
        'gbprod/yanky.nvim',
        config = function()
            require('plugins.yanky')
        end,
    })

    -- Utils
    use({
        'vimwiki/vimwiki',
        config = function()
            require('plugins.vimwiki')
        end,
    })
    use({
        'godlygeek/tabular',
        cmd = { 'Tabularize', 'Tab' },
    })
    use({ 'blindFS/vim-colorpicker', cmd = 'ColorPicker' })
    use({
        'benmills/vimux', -- run comand(test) in split tmux pane
        config = function()
            require('plugins.vimux')
        end,
    })
    use({
        'yssl/QFEnter', -- quickfix window (cw) open in split/tab...
        config = function()
            require('plugins.QFEnter')
        end,
    })
    use({
        'simeji/winresizer',
        config = function()
            require('plugins.winresizer')
        end,
    })
    use({
        'christoomey/vim-tmux-navigator',
        config = function()
            require('plugins.vim-tmux-navigator')
        end,
    })
    use({
        'nvim-lualine/lualine.nvim',
        config = function()
            require('plugins.lualine') -- "tabline" for buffers.
        end,
    })
    use({
        'folke/which-key.nvim',
        config = function()
            require('plugins.which-key')
        end,
    })
    use('stevearc/dressing.nvim')

    -- Look and feel
    use({
        'morhetz/gruvbox',
        config = function()
            require('theme')
        end,
    })
    use('lukas-reineke/indent-blankline.nvim') -- Add indentation guides even on blank lines
    use({
        'blueyed/vim-diminactive',
        config = function()
            require('plugins.vim-diminactive')
        end,
    })
    use({
        'lilydjwg/colorizer',
        config = function()
            require('plugins.colorizer')
        end,
        cmd = { 'ColorHighlight', 'ColorToggle' },
    })
    use({
        'RRethy/vim-illuminate', -- automatically highlighting other uses of the word under the cursor
        config = function()
            require('plugins.illuminate')
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if bootstraping then
        require('packer').sync()
    end
end)
