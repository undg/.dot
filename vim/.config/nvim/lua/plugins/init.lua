-- Automatically install packer and asigning global variable `PACKER_BOOTSTRAP` that is used at the end of this file.
-- local bootstrap_ok, _ = pcall(require, 'bootstrap')
-- if not bootstrap_ok then
--     print('lua/plugins/init.lua: bootstrap fail')
--     return
-- end


local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local PACKER_BOOTSTRAP = ensure_packer()








local packer_ok, packer = pcall(require, 'packer')
if not packer_ok then
    print('nvim/lua/plugins/init.lua: packer fail')
    return
end

packer.startup(function(use)
    -- Core
    use('wbthomason/packer.nvim') -- This plugin manager
    use('nvim-lua/plenary.nvim') -- All the lua functions you don't want to write twice.
    use({
        'lewis6991/impatient.nvim',
        config = function()
            require('impatient')
        end,
    }) -- Cache for plugins

    -- Dependencies
    use('onsails/lspkind-nvim') -- icons
    use({
        'nvim-tree/nvim-web-devicons', -- fork from nvim-tree
        config = function()
            require('plugins.nvim-web-devicons')
        end,
    }) -- icons

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
    })

    -- Git
    use({
        'kdheepak/lazygit.nvim',
        config = function()
            require('plugins.lazygit')
        end,
    })
    use('tpope/vim-fugitive') -- Git commands in nvim
    use({ 'tpope/vim-rhubarb' }) -- Fugitive-companion to interact with github
    use({
        'lewis6991/gitsigns.nvim', -- Git status for every line
        config = function()
            require('plugins.gitsigns')
        end,
    })

    -- File managers
    use({
        'nvim-tree/nvim-tree.lua',
        -- requires "nvim-web-devicons", -- installed separately in top of this file
        config = function()
            require('plugins.nvim-tree')
        end,
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
    })
    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            -- "nvim-web-devicons", -- installed separately in top of this file
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
    use('neovim/nvim-lspconfig') -- Collection of configurations for built-in LSP client
    -- use({ "williamboman/nvim-lsp-installer" }) -- Installation servers for LSP
    use({ 'williamboman/mason.nvim' })
    use({ 'williamboman/mason-lspconfig.nvim' })
    use({
        'tami5/lspsaga.nvim',
        config = function()
            require('plugins.lspsaga')
        end,
    }) -- LSP utils with performant UI
    use('jose-elias-alvarez/typescript.nvim') -- few extra commands for ts. Uses LSP

    -- Syntax
    use({
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('plugins.treesitter')
        end,
    }) -- Highlight, edit, and navigate code using a fast incremental parsing library
    use('nvim-treesitter/nvim-treesitter-textobjects') -- Additional text objects for treesitter
    use('p00f/nvim-ts-rainbow') -- parenthesis rainbow, treesitter version
    use({
        'mhartington/formatter.nvim', -- prettier
        config = function()
            require('plugins.formatter')
        end,
    })

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
    use({
        'ziontee113/icon-picker.nvim',
        config = function()
            require('icon-picker').setup({
                disable_legacy_commands = true,
            })
        end,
    })

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
        'RRethy/vim-illuminate',
        config = function()
            require('plugins.illuminate')
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
