return {
    'MeanderingProgrammer/render-markdown.nvim',                                         -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
        file_types = { 'markdown', 'Avante' },
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
