return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring', -- helper plugin for comment str,
        -- Highlight, edit, and navigate code using a fast incremental parsing library
        'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects for treesitter
    },
    build = ':TSUpdate',
    config = function()
        local ok_ts_configs, ts_configs = pcall(require, 'nvim-treesitter.configs')
        if not ok_ts_configs then
            print('plugins/treesitter.configs.lua: missing requirements')
            return
        end

        -- Treesitter configuration
        -- Parsers must be installed manually via :TSInstall
        ts_configs.setup({
            modules = {},
            ignore_install = {},
            ensure_installed = {
                'html',
                'css',
                'scss',
                'graphql',
                'javascript',
                'jsdoc',
                'jsonc',
                'lua',
                'markdown',
                'markdown_inline',
                'python',
                'tsx',
                'typescript',
                'vim',
                'yaml',
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true, -- false will disable the whole extension
                use_languagetree = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'gnn',
                    scope_incremental = 'gnm',
                    node_decremental = 'gmm',
                },
            },
            indent = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
            },
            context_commentstring = {
                enable = true,
                -- enable_autocmd = false,
                -- config = { },
            },
            rainbow = {
                enable = true,
                -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = nil, -- Do not enable for files with more than n lines, int
                -- colors = {}, -- table of hex strings
                -- termcolors = {} -- table of colour name strings
            },
        })
    end,
}