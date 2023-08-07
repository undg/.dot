return {
    'jose-elias-alvarez/typescript.nvim', -- few extra commands for ts. Uses LSP
    {

        'marilari88/twoslash-queries.nvim', -- // live type checking with //  ^?
        config = {
            multi_line = true,              -- to print types in multi line mode
            is_enabled = true,              -- to keep disabled at startup and enable it on request with the EnableTwoslashQueries
            highlight = 'DevIconBat',       -- to set up a highlight group for the virtual text
        },

        keys = {
            { '<leader>si', ':TwoslashQueriesInspect<CR>', desc = 'Twoslash Instpect' },
            { '<leader>sr', ':TwoslashQueriesRemove<CR>',  desc = 'Twoslash Remove' },
        },
    },
}
