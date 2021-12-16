local packer = require('packer')
local use = packer.use
packer.startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim' -- All the lua functions you don't want to write twice.

    use 'tpope/vim-repeat' -- dot repeat for plugins like surround @TODO fix it
    use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
    use 'tpope/vim-sleuth' -- Auto-detect intentation style
    use 'tpope/vim-surround' -- @TODO 🐛 fix it

    -- Git
    use 'tpope/vim-fugitive' -- Git commands in nvim
    use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
    use 'airblade/vim-gitgutter' -- Git status for every line

    -- File managers
    use {
        'scrooloose/nerdtree',
        requires = {
            'jistr/vim-nerdtree-tabs',
            'Xuyuanp/nerdtree-git-plugin',
        },
        config = function() require('plugins.nerdtree') end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'kyazdani42/nvim-web-devicons',
        },
        config = function () require('plugins.telescope') end
    }

    -- LSP
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'williamboman/nvim-lsp-installer' -- Instalation servers for LSP
    -- use 'glepnir/lspsaga.nvim' -- LSP utils with performant UI
    use { 'tami5/lspsaga.nvim', config = function () require'plugins.lspsaga' end } -- LSP utils with performant UI
    use 'nvim-treesitter/nvim-treesitter' -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- Additional textobjects for treesitter

    -- Autocompletion
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'onsails/lspkind-nvim'
    use 'L3MON4D3/LuaSnip' -- Snippets plugin

    -- AutoFormatting
    -- use {
    --     'jose-elias-alvarez/null-ls.nvim',
    --         config = function ()
    --             vim.cmd("nnoremap <buffer> <Leader>fp :lua vim.lsp.buf.formatting()<CR>")
    --             require'null_ls'.setup({
    --             on_attach = function(client, bufnr)
    --                 if client.resolved_capabilities.document_formatting then
    --                     vim.cmd("nnoremap <buffer> <Leader>fp :lua vim.lsp.buf.formatting()<CR>")
    --                     -- format on save
    --                     -- vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
    --                 end

    --                 if client.resolved_capabilities.document_range_formatting then
    --                     vim.cmd("xnoremap <buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
    --                 end
    --             end,
    --         })

    --     end
    -- }
    use {
        'MunifTanjim/prettier.nvim',
        -- requires = {
        --     'neovim/nvim-lspconfig',
        -- },
        -- config = function () require'plugins.prettier' end
    }
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require('plugins.trouble') end
    }


    -- Utils
    use  'yssl/QFEnter' -- quickfix window (cw) open in split/tab...
    -- use 'bfredl/nvim-miniyank' -- 🐛@TODO @WIP
    use 'svermeulen/vim-yoink'
    use 'jiangmiao/auto-pairs'
    use { 'simnalamburt/vim-mundo', cmd = {'MundoShow', 'MundoToggle'} }
    use { 'vimwiki/vimwiki', config = function() require'plugins.vimwiki' end }
    use { 'rhysd/vim-grammarous', cmd = 'GrammarousCheck' }
    use { 'simeji/winresizer', config = function() require'plugins.winresizer' end }
    use { 'christoomey/vim-tmux-navigator', config = function() require'plugins.vim-tmux-navigator' end }
    use { 'benmills/vimux', config = function() require'plugins.vimux' end }
    use { 'AndrewRadev/linediff.vim', cmd = 'Linediff'  }
    use { 'und3rdg/Tabmerge', cmd = 'Tabmerge' }
    use { 'lilydjwg/colorizer', config = function() require'plugins.colorizer' end, cmd = { 'ColorHighlight', 'ColorToggle'} }
    use { 'blindFS/vim-colorpicker',  cmd = 'ColorPicker' }
    use { 'troydm/zoomwintab.vim' }

    -- Theme
    use 'morhetz/gruvbox'
    -- use 'itchyny/lightline.vim' -- Fancier statusline
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use 'blueyed/vim-diminactive'
end)
