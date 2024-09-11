return {
    'MeanderingProgrammer/render-markdown.nvim',                                         -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
        file_types = { 'markdown', 'Avante' },
    },

    ft = { 'markdown', 'Avante' },
}
