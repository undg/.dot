return {

    'danielfalk/smart-open.nvim',                                       -- https://github.com/danielfalk/smart-open.nvim
    dependencies = {
        'kkharji/sqlite.lua',                                           -- https://github.com/kkharji/sqlite.lua
        'nvim-telescope/telescope.nvim',                                -- https://github.com/nvim-telescope/telescope.nvim
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- Only required if using match_algorithm fzf
        -- { 'nvim-telescope/telescope-fzy-native.nvim' },                 -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    },
    config = function()
        require('telescope').load_extension('smart_open')
    end,
}
