-- https://github.com/pmizio/typescript-tools.nvim

-- https://github.com/nvim-lua/plenary.nvim
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/marilari88/twoslash-queries.nvim

return {
    {
        'pmizio/typescript-tools.nvim',
        ft = {'typescript' ,'typescriptreact', 'javascript', 'javascriptreact' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'neovim/nvim-lspconfig',
            {

                'marilari88/twoslash-queries.nvim', -- // live type checking with //  ^?
                opts = {
                    multi_line = true,              -- to print types in multi line mode
                    is_enabled = true,              -- to keep disabled at startup and enable it on request with the EnableTwoslashQueries
                    highlight = 'DevIconBat',       -- to set up a highlight group for the virtual text
                },

                cmd = 'TwoslashQueriesInspect',

                keys = {
                    { '<leader>si', ':TwoslashQueriesInspect<CR>', desc = 'Twoslash Instpect' },
                    { '<leader>sd', ':TwoslashQueriesRemove<CR>',  desc = 'Twoslash Remove' },
                },
            },
        },
        opts = {
            on_attach = function(client, bufnr)
                require('twoslash-queries').attach(client, bufnr)
            end,
            settings = {
                separate_diagnostic_server = true,
                publish_diagnostic_on = 'insert_leave',
                -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
                -- "remove_unused_imports"|"organize_imports") -- or string "all"
                -- to include all supported code actions
                -- specify commands exposed as code_actions
                expose_as_code_action = { 'fix_all', 'add_missing_imports', 'remove_unused', 'organize_imports' },
                tsserver_path = nil,
                -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                -- (see 💅 `styled-components` support section)
                tsserver_plugins = {
                    '@styled/typescript-styled-plugin',
                },
                -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                -- memory limit in megabytes or "auto"(basically no limit)
                tsserver_max_memory = 'auto',
                -- described below
                tsserver_format_options = {},
                tsserver_file_preferences = {},
                -- locale of all tsserver messages, supported locales you can find here:
                -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                tsserver_locale = 'en',
                -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                complete_function_calls = false,
                include_completions_with_insert_text = true,
                -- CodeLens
                -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                code_lens = 'off',
                -- by default code lenses are displayed on all referencable values and for some of you it can
                -- be too much this option reduce count of them by removing member references from lenses
                disable_member_code_lens = true,
                -- JSXCloseTag
                -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
                -- that maybe have a conflict if enable this feature. )
                jsx_close_tag = {
                    enable = false,
                    filetypes = { 'javascriptreact', 'typescriptreact' },
                },
            },
        },
    },
}