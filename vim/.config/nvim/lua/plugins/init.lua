-- Automatically install packer
-- `git clone --depth 1 https://github.com/wbthomason/packer.nvim\ ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })

    -- Some mac issues, Ref: https://github.com/wbthomason/packer.nvim/issues/739#issuecomment-1019280631
    vim.o.runtimepath = vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath
end

-- Autocommand that reloads neovim whenever you save the plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

local use = packer.use
packer.startup(function()
    -- Core
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim") -- All the lua functions you don't want to write twice.

    -- Dependencies
    use("onsails/lspkind-nvim") -- icons

    -- Productivity
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("plugins/Comment")
        end,
    })
    use("tpope/vim-sleuth") -- Auto-detect intentation style
    use("tpope/vim-repeat") -- dot repeat for plugins like surround
    use("tpope/vim-surround") -- motions to change brackets
    use("jiangmiao/auto-pairs")
    use({
        "folke/trouble.nvim",
        config = function()
            require("plugins/trouble")
        end,
    })
    use({
        "goolord/alpha-nvim",
        config = function()
            require("plugins/alpha")
        end,
    })
    use({ "nvim-telescope/telescope-project.nvim" })

    -- Git
    use({
        "kdheepak/lazygit.nvim",
        config = function()
            require("plugins/lazygit")
        end,
    })
    use("tpope/vim-fugitive") -- Git commands in nvim
    use({ "tpope/vim-rhubarb" }) -- Fugitive-companion to interact with github
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
    use({
        "mhartington/formatter.nvim", -- prettier
        config = function()
            require("plugins/formatter")
        end,
    })

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

    -- Registers
    use({ "simnalamburt/vim-mundo", cmd = { "MundoShow", "MundoToggle" } })
    use({
        "gbprod/yanky.nvim",
        config = function()
            require("plugins/yanky")
        end,
    })

    -- Utils
    use({
        "vimwiki/vimwiki",
        config = function()
            require("plugins/vimwiki")
        end,
    })
    use({
        "godlygeek/tabular",
        cmd = { "Tabularize" },
        config = function()
            require("plugins/tabular")
        end,
    })
    use({ "blindFS/vim-colorpicker", cmd = "ColorPicker" })
    use({
        "benmills/vimux",
        config = function()
            require("plugins/vimux")
        end,
    })

    -- Layout
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

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
