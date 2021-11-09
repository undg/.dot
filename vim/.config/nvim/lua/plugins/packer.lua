local packer = require('packer')
local use = packer.use
packer.startup(function()
    use 'wbthomason/packer.nvim'

    use 'nvim-lua/plenary.nvim' -- All the lua functions I don't want to write twice.

    use 'morhetz/gruvbox'
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines

    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive' -- Git commands in nvim
    use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
    use 'airblade/vim-gitgutter' -- Git status for every line
    use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines

    use 'scrooloose/nerdtree'
    use 'jistr/vim-nerdtree-tabs'
    use 'Xuyuanp/nerdtree-git-plugin'

    use { 'junegunn/fzf', run = './install --bin', }
    use { 'ibhagwan/fzf-lua',
        requires = {
            'vijaymarupudi/nvim-fzf',
            'kyazdani42/nvim-web-devicons'
        }
    }

    -- quickfix window (cw) open in split/tab...
    use  'yssl/QFEnter'
    -- use 'bfredl/nvim-miniyank'

    use 'itchyny/lightline.vim' -- Fancier statusline

    use 'nvim-treesitter/nvim-treesitter' -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- Additional textobjects for treesitter
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'williamboman/nvim-lsp-installer' -- Instalation servers for LSP
    -- use 'glepnir/lspsaga.nvim' -- LSP utils with performant UI
    use 'tami5/lspsaga.nvim' -- LSP utils with performant UI

    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)

