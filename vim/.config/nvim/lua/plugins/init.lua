local packer = require("packer")
local use = packer.use
packer.startup(function()
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim") -- All the lua functions you don't want to write twice.

    use("tpope/vim-repeat") -- dot repeat for plugins like surround @TODO fix it
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("plugins/Comment")
        end,
    })
    use("tpope/vim-sleuth") -- Auto-detect intentation style
    use("tpope/vim-surround") -- @TODO 🐛 fix it... fucking stupid comment! fix what?

    -- Git
    use("tpope/vim-fugitive") -- Git commands in nvim
    use("tpope/vim-rhubarb") -- Fugitive-companion to interact with github
    use({
        "lewis6991/gitsigns.nvim", -- Git status for every line
        config = function()
            require("plugins/gitsigns")
        end,
    })

    -- File managers
    use({
        "scrooloose/nerdtree",
        requires = {
            "jistr/vim-nerdtree-tabs",
            "Xuyuanp/nerdtree-git-plugin",
        },
        config = function()
            require("plugins/nerdtree")
        end,
    })
    use({
        "gbprod/yanky.nvim",
        config = function()
            require("plugins/yanky")
        end,
    })
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            {
                "kyazdani42/nvim-web-devicons",
                config = function()
                    require("plugins/nvim-web-devicons")
                end,
            },
            {
                "ThePrimeagen/harpoon",
                config = function()
                    require("plugins/harpoon")
                end,
            },
        },
        config = function()
            require("plugins/telescope")
        end,
    })

    -- LSP
    use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
    -- use({ "williamboman/nvim-lsp-installer" }) -- Instalation servers for LSP
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })
    use({
        "tami5/lspsaga.nvim",
        config = function()
            require("plugins/lspsaga")
        end,
    }) -- LSP utils with performant UI
    use("jose-elias-alvarez/typescript.nvim") -- few extra commands for ts. Uses LSP

    -- Syntax
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("plugins/treesitter")
        end,
    }) -- Highlight, edit, and navigate code using a fast incremental parsing library
    use("nvim-treesitter/nvim-treesitter-textobjects") -- Additional textobjects for treesitter
    use("p00f/nvim-ts-rainbow") -- parentesis rainbow, treesitter version

    -- snippets are integrated with autocompletion nvim-cmp
    use("SirVer/ultisnips")
    use("quangnguyen30192/cmp-nvim-ultisnips")

    -- Autocompletion
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins/nvim-cmp")
        end,
    })
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-nvim-lsp")

    use("onsails/lspkind-nvim") -- icons

    -- prettier
    use({
        "mhartington/formatter.nvim",
        config = function()
            require("plugins/formatter")
        end,
    })

    use({
        "folke/trouble.nvim",
        config = function()
            require("plugins/trouble")
        end,
    })

    -- Utils
    use("jiangmiao/auto-pairs")
    use({ "simnalamburt/vim-mundo", cmd = { "MundoShow", "MundoToggle" } })
    use({
        "vimwiki/vimwiki",
        config = function()
            require("plugins/vimwiki")
        end,
    })
    use({ "rhysd/vim-grammarous", cmd = "GrammarousCheck" })
    -- use({
    --     "rafcamlet/nvim-luapad",
    --     cmd = { "Luapad", "LuaRun" },
    --     config = function()
    --         require("plugins/luapad")
    --     end,
    -- })
    use({
        "godlygeek/tabular",
        cmd = { "Tabularize" },
        config = function()
            require("plugins/tabular")
        end,
    })
    use({ "blindFS/vim-colorpicker", cmd = "ColorPicker" })

    -- UI
    use({
        "yssl/QFEnter", -- quickfix window (cw) open in split/tab...
        config = function()
            require("plugins/QFEnter")
        end,
    })
    use({
        "simeji/winresizer",
        config = function()
            require("plugins/winresizer")
        end,
    })
    use({
        "christoomey/vim-tmux-navigator",
        config = function()
            require("plugins/vim-tmux-navigator")
        end,
    })
    use({ "benmills/vimux" })

    -- Theme
    use({
        "morhetz/gruvbox",
        config = function()
            require("theme")
        end,
    })
    use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
    use({
        "blueyed/vim-diminactive",
        config = function()
            require("plugins/vim-diminactive")
        end,
    })
    use({
        "lilydjwg/colorizer",
        config = function()
            require("plugins/colorizer")
        end,
        cmd = { "ColorHighlight", "ColorToggle" },
    })
end)
