return {
    'MeanderingProgrammer/render-markdown.nvim',                                         -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
        file_types = { 'markdown', 'Avante' },
        win_options = {
            -- See :h 'conceallevel'
            conceallevel = {
                -- Used when not being rendered, get user setting
                default = vim.api.nvim_get_option_value('conceallevel', {}),
                -- Used when being rendered, concealed text is completely hidden
                rendered = 3,
            },
            -- See :h 'concealcursor'
            concealcursor = {
                -- Used when not being rendered, get user setting
                default = vim.api.nvim_get_option_value('concealcursor', {}),
                -- Used when being rendered, disable concealing text in all modes
                rendered = '',
            },
        },
        bullet = {
            right_pad = 1,
        },
        code = {
            width = 'block',
            right_pad = 4,
            min_width = 10,
        },
    },

    ft = { 'markdown', 'Avante' },
}
